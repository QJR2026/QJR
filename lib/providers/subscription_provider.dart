import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/repositories/payment_repository.dart';

import '../services/api_service.dart';
import '../utils/custom_snackbar.dart';
import '../utils/device_info.dart';
import '../utils/error_handler.dart';
import '../utils/navigation_helper.dart';
import '../utils/routes.dart';
import '../views/payment/edit_payment_plan_screen.dart';
import '../views/payment/subscription_screen.dart';

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  bool isAvailable = false;
  bool isLoading = true;
  bool isProcessing = false;
  bool isSubscribed = false;
  bool _isInitialized = false;

  String? productsError;

  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  String? activeProductId;
  String? expiresAt;

  final List<String> logs = [];
  final Set<String> _processedTransactionIds = {};
  String? _pendingProductId;

  bool _hasNavigatedToHome = false;
  bool _isRestoring = false;
  bool _listenerAttached = false;

  /// Serializes async purchase-stream handlers so they cannot race on shared state.
  Future<void> _purchaseUpdateChain = Future.value();

  Timer? _purchaseWatchdog;
  Timer? _restoreTimeoutTimer;

  static const String kMonthlyProductId = 'monthly_plan';
  static const String kYearlyProductId = 'yearly_plan';
  static const Set<String> _kIds = {kMonthlyProductId, kYearlyProductId};

  final paymentRepo = PaymentRepository();

  String _friendlyIAPError(IAPError? error) {
    if (error == null) {
      return 'Something went wrong with your purchase. Please try again.';
    }
    final code = error.code;
    // For PurchaseStatus.error stream events the plugin sets:
    //   code    = 'purchase_error'  (always)
    //   message = the error domain string ('SKErrorDomain', 'NSURLErrorDomain', …)
    // For direct PlatformException throws from buyNonConsumable/restorePurchases:
    //   code    = the PlatformException code (e.g. 'storekit_duplicate_product_object')
    //   message = the exception message
    final domain = error.message;

    // Plugin-level codes — only appear on direct throws, not stream events.
    if (code == 'storekit_duplicate_product_object') {
      return 'A purchase is already in progress. Please wait a moment and try again.';
    }

    // Domain-based checks — reliable for stream errors.
    if (domain == 'NSURLErrorDomain' || domain.contains('NSURLErrorDomain')) {
      return 'A network error occurred. Please check your connection and try again.';
    }
    if (domain == 'SKErrorDomain' || domain.contains('SKErrorDomain')) {
      return 'Something went wrong with your purchase. Please try again.';
    }

    // Fallback: message-text checks for any non-standard formats.
    if (domain.toLowerCase().contains('network') ||
        domain.toLowerCase().contains('internet') ||
        domain.toLowerCase().contains('connection')) {
      return 'A network error occurred. Please check your connection and try again.';
    }
    if (domain.contains('NSError') || domain.contains('Domain=')) {
      return 'Something went wrong with your purchase. Please try again.';
    }

    return domain.isNotEmpty
        ? domain
        : 'Something went wrong with your purchase. Please try again.';
  }

  void _addToProcessed(String id) {
    if (_processedTransactionIds.length >= 100) _processedTransactionIds.clear();
    _processedTransactionIds.add(id);
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final logEntry = "[$timestamp] $message";
    if (kDebugMode) print("🟢 IAP: $logEntry");
    logs.insert(0, logEntry);
    if (logs.length > 200) logs.removeLast();
    notifyListeners();
  }

  /// Accepts both flat and `{ data: { ... } }` backend shapes.
  Map<String, dynamic> _normalizeSubscriptionResult(dynamic result) {
    if (result is! Map) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(result);
    final data = map['data'];
    if (data is Map) {
      final nested = Map<String, dynamic>.from(data);
      return <String, dynamic>{
        'success': map['success'] ?? nested['success'] ?? true,
        'isActive': map['isActive'] ?? nested['isActive'] ?? false,
        'expiresAt': map['expiresAt'] ?? nested['expiresAt'],
        'productId': map['productId'] ?? nested['productId'],
        'message': map['message'] ?? nested['message'],
      };
    }
    return map;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      _addLog('⚠️ Already initialized, skipping...');
      return;
    }

    _addLog('Initializing In-App Purchase...');

    try {
      // Attach listener once, before touching the queue, so purchased events are not lost.
      if (!_listenerAttached) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          _enqueuePurchaseUpdates,
          onError: (error) => _addLog('❌ Purchase stream error: $error'),
          onDone: () => _addLog('✅ Purchase stream closed'),
        );
        _listenerAttached = true;
        _addLog('✅ Purchase stream listener attached');
      }

      // Only finish failed transactions — never finish purchased/restored here.
      await _finishFailedTransactions();

      await initStoreInfo();

      if (isAvailable) {
        _addLog('Store available — checking previous purchases...');
        await checkDeviceSubscriptionOnServer();
      }

      _isInitialized = true;
    } catch (e) {
      _addLog('❌ Initialization error: $e');
      // Allow a later retry; keep listener if already attached.
    }
  }

  Future<void> initStoreInfo() async {
    try {
      if (products.isNotEmpty) return;
      isLoading = true;
      productsError = null;
      notifyListeners();

      isAvailable = await _inAppPurchase.isAvailable();
      _addLog('Store available: $isAvailable');

      if (!isAvailable) {
        isLoading = false;
        productsError = "In-app purchases aren't available on this device.";
        notifyListeners();
        return;
      }

      final ProductDetailsResponse response;
      try {
        response = await _inAppPurchase
            .queryProductDetails(_kIds)
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        isLoading = false;
        productsError =
            "This is taking longer than expected. Please check your connection and try again.";
        notifyListeners();
        _addLog(
            '⌛ Product query timed out — check simulator/sandbox account/App Store Connect agreements');
        return;
      }

      isLoading = false;
      if (response.error != null) {
        productsError = response.error?.message.isNotEmpty == true
            ? response.error!.message
            : "We couldn't load the subscription plans from the App Store. Please try again.";
        notifyListeners();
        _addLog('❌ Product query error: ${response.error}');
        return;
      }

      if (response.productDetails.isEmpty) {
        productsError = 'No subscription plans are available right now.';
        notifyListeners();
        _addLog('⚠️ No products found for IDs: $_kIds');
        return;
      }

      products = response.productDetails;
      notifyListeners();
      _addLog('✅ Products fetched: ${products.map((p) => p.id).join(", ")}');
    } catch (e) {
      isLoading = false;
      productsError =
          'Something went wrong while loading plans. Please try again.';
      notifyListeners();
      _addLog('❌ _initStoreInfo error: $e');
    }
  }

  Future<void> retryLoadProducts() => initStoreInfo();

  ProductDetails? get activePlan {
    if (activeProductId == null || products.isEmpty) return null;
    try {
      return products.firstWhere((val) => val.id == activeProductId);
    } catch (e) {
      return null;
    }
  }

  ProductDetails? get otherThanActivePlan {
    if (activeProductId == null || products.isEmpty) return null;
    try {
      return products.firstWhere((val) => val.id != activeProductId);
    } catch (e) {
      return null;
    }
  }

  /// Finishes only failed StoreKit transactions. Purchased/restored must go
  /// through the purchase stream → verify → completePurchase path.
  Future<void> _finishFailedTransactions() async {
    try {
      _addLog('🧹 Finishing failed transactions only...');
      final wrapper = SKPaymentQueueWrapper();
      final transactions = await wrapper.transactions();

      if (transactions.isEmpty) {
        _addLog('✅ No pending transactions');
        return;
      }

      _addLog('Found ${transactions.length} transaction(s)');

      for (final transaction in transactions) {
        final state = transaction.transactionState;
        if (state != SKPaymentTransactionStateWrapper.failed) {
          _addLog(
              '⏭️ Leaving $state transaction for purchase stream: ${transaction.transactionIdentifier}');
          continue;
        }
        try {
          await wrapper.finishTransaction(transaction);
          final id = transaction.transactionIdentifier;
          if (id != null) _addToProcessed(id);
          _addLog('✅ Finished failed: $id');
        } catch (e) {
          _addLog('⚠️ Error finishing failed transaction: $e');
        }
      }
    } catch (e) {
      _addLog('❌ Error finishing failed transactions: $e');
    }
  }

  Future<void> buy(ProductDetails product) async {
    if (isProcessing) {
      _addLog('⚠️ Already processing a purchase');
      return;
    }

    if (_pendingProductId == product.id) {
      _addLog('⚠️ Purchase already in progress for ${product.id}');
      return;
    }

    _pendingProductId = product.id;
    _hasNavigatedToHome = false;
    isProcessing = true;
    notifyListeners();
    _armPurchaseWatchdog();

    try {
      _addLog('💰 Starting purchase: ${product.id}');
      await _finishFailedTransactions();

      final param = PurchaseParam(productDetails: product);
      await _inAppPurchase
          .buyNonConsumable(purchaseParam: param)
          .timeout(const Duration(seconds: 30));

      _addLog('✅ Purchase request sent to store');
    } on TimeoutException {
      _addLog('⌛ Purchase request timed out');
      CustomSnackBar.showError(
        message: 'The purchase request is taking too long. Please try again.',
      );
      _resetPurchaseState();
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        // Product is still in-flight — keep _pendingProductId set so the
        // existing stream event still navigates to home when it arrives.
        _addLog('⏳ Already in StoreKit queue — waiting for existing transaction');
        isProcessing = false;
        notifyListeners();
        CustomSnackBar.showPrimary(
          message: 'Your purchase is already being processed. Please wait.',
        );
      } else {
        _addLog('❌ Purchase error: ${e.code} ${e.message}');
        CustomSnackBar.showError(
          message: 'Something went wrong with your purchase. Please try again.',
        );
        _resetPurchaseState();
      }
    } catch (e) {
      _addLog('❌ Purchase error: $e');
      CustomSnackBar.showError(
        message: 'Something went wrong with your purchase. Please try again.',
      );
      _resetPurchaseState();
    }
  }

  Future<void> changeSubscription(ProductDetails newProduct) async {
    if (isProcessing) {
      _addLog('⚠️ Already processing a request');
      return;
    }

    if (!isSubscribed) {
      _addLog('⚠️ No active subscription to change');
      return;
    }

    if (activeProductId == newProduct.id) {
      _addLog('⚠️ Already subscribed to ${newProduct.id}');
      return;
    }

    _pendingProductId = newProduct.id;
    _hasNavigatedToHome = false;
    isProcessing = true;
    notifyListeners();
    _armPurchaseWatchdog();

    try {
      _addLog('🔄 Changing subscription: $activeProductId → ${newProduct.id}');
      await _finishFailedTransactions();

      final remaining = await SKPaymentQueueWrapper().transactions();
      if (remaining.any((t) => t.payment.productIdentifier == newProduct.id)) {
        _addLog('⏳ Already in StoreKit queue — waiting for existing transaction');
        isProcessing = false;
        notifyListeners();
        return;
      }

      final param = PurchaseParam(productDetails: newProduct);
      await _inAppPurchase
          .buyNonConsumable(purchaseParam: param)
          .timeout(const Duration(seconds: 30));

      _addLog('✅ Subscription change request sent to store');
    } on TimeoutException {
      _addLog('⌛ Subscription change request timed out');
      CustomSnackBar.showError(
        message: 'The request is taking too long. Please try again.',
      );
      _resetPurchaseState();
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        _addLog('⏳ Already in StoreKit queue — waiting for existing transaction');
        isProcessing = false;
        notifyListeners();
        CustomSnackBar.showPrimary(
          message: 'Your purchase is already being processed. Please wait.',
        );
      } else {
        _addLog('❌ Change subscription error: ${e.code} ${e.message}');
        CustomSnackBar.showError(
          message: 'Something went wrong. Please try again.',
        );
        _resetPurchaseState();
      }
    } catch (e) {
      _addLog('❌ Change subscription error: $e');
      CustomSnackBar.showError(message: 'Something went wrong. Please try again.');
      _resetPurchaseState();
    }
  }

  Future<void> restorePurchases() async {
    if (isProcessing || _isRestoring) return;

    try {
      _addLog('♻️ Restoring purchases...');
      isProcessing = true;
      _isRestoring = true;
      _hasNavigatedToHome = false;
      notifyListeners();

      await _finishFailedTransactions();
      await _inAppPurchase.restorePurchases();
      // Keep isProcessing / _isRestoring until stream events arrive or timeout.
      _restoreTimeoutTimer?.cancel();
      _restoreTimeoutTimer = Timer(const Duration(seconds: 15), () async {
        if (!_isRestoring) return;
        _addLog('⚠️ Restore timed out — checking server before giving up');
        _isRestoring = false;
        isProcessing = false;
        notifyListeners();
        try {
          final active = await checkDeviceSubscriptionOnServer();
          if (active && SubscriptionScreen.isOnSubscriptionPage) {
            await _navigateToHome();
            return;
          }
        } catch (_) {}
        CustomSnackBar.showError(
          message: 'No previous purchases found to restore.',
        );
      });
    } catch (e) {
      _addLog('❌ Restore error: $e');
      _isRestoring = false;
      isProcessing = false;
      _restoreTimeoutTimer?.cancel();
      CustomSnackBar.showError(message: 'Failed to restore purchases. Please try again.');
      notifyListeners();
    }
  }

  void _enqueuePurchaseUpdates(List<PurchaseDetails> list) {
    _purchaseUpdateChain = _purchaseUpdateChain
        .then((_) => _handlePurchaseUpdates(list))
        .catchError((Object e) {
      _addLog('❌ Purchase queue error: $e');
    });
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> list) async {
    _addLog('🔄 Purchase updates: ${list.length}');
    purchases = list;

    for (final purchase in list) {
      final purchaseId = purchase.purchaseID ??
          '${purchase.productID}-${purchase.transactionDate}';

      final isExpectedChange =
          _pendingProductId != null && purchase.productID == _pendingProductId;

      if (_processedTransactionIds.contains(purchaseId) && !isExpectedChange) {
        _addLog('⏭️ Skipping already processed: $purchaseId');
        // User may be stuck on subscription after a prior success — recover.
        if (purchase.status == PurchaseStatus.purchased &&
            SubscriptionScreen.isOnSubscriptionPage &&
            !_hasNavigatedToHome) {
          await _fallbackNavigateIfActive();
        }
        continue;
      }

      if (isExpectedChange) {
        _addLog(
            '🔄 Processing expected upgrade/downgrade: ${purchase.productID}');
        _processedTransactionIds.remove(purchaseId);
      }

      _addLog('🧾 ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          final wasUserInitiated =
              _pendingProductId != null || _isRestoring;
          if (wasUserInitiated) {
            // Explicit buy / change / in-flight restore — verify + UI feedback.
            final ok = await _handleSuccessfulPurchase(purchase);
            if (ok) _addToProcessed(purchaseId);
          } else if (!isSubscribed) {
            // Not subscribed yet (e.g. paywall) — verify so activation can proceed.
            final ok = await _handleSuccessfulPurchase(purchase);
            if (ok) _addToProcessed(purchaseId);
          } else {
            // Already subscribed + not user-initiated = stale StoreKit redelivery.
            // Finish only — never re-verify / change activeProductId / pop / snackbar.
            _addLog(
                '⏭️ Finishing stale transaction: ${purchase.productID}');
            await _completePurchase(purchase);
            _addToProcessed(purchaseId);
            if (SubscriptionScreen.isOnSubscriptionPage &&
                !_hasNavigatedToHome) {
              await _fallbackNavigateIfActive();
            }
          }
          break;

        case PurchaseStatus.restored:
          // Only honor restore events from an explicit restorePurchases() call.
          // Unexpected restored redeliveries must not flip activeProductId / selection.
          if (!_isRestoring) {
            _addLog(
                '⏭️ Ignoring unexpected restored event: ${purchase.productID}');
            await _completePurchase(purchase);
            _addToProcessed(purchaseId);
            break;
          }
          final ok = await _handleSuccessfulPurchase(purchase);
          if (ok) _addToProcessed(purchaseId);
          _restoreTimeoutTimer?.cancel();
          _isRestoring = false;
          break;

        case PurchaseStatus.error:
          _addLog('❌ Error: ${purchase.error?.message}');
          _addToProcessed(purchaseId);
          CustomSnackBar.showError(message: _friendlyIAPError(purchase.error));
          await _completePurchase(purchase);
          _resetPurchaseState();
          break;

        case PurchaseStatus.canceled:
          _addLog('⚠️ Purchase canceled');
          _addToProcessed(purchaseId);
          await _completePurchase(purchase);
          _resetPurchaseState();
          break;

        case PurchaseStatus.pending:
          _addLog('⏳ Pending (Ask to Buy / deferred)...');
          // Keep _pendingProductId + isProcessing so approval can complete later.
          isProcessing = true;
          notifyListeners();
          CustomSnackBar.showPrimary(
            message:
                'Your purchase is pending approval. We\'ll continue once it\'s approved.',
          );
          break;
      }
    }
  }

  /// Returns true when the purchase was fully handled (verified or rejected by
  /// backend). Returns false on transport errors so StoreKit can redeliver.
  Future<bool> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    _addLog('✅ Purchase successful: ${purchase.productID}');

    final isUpgrade = isSubscribed && activeProductId != purchase.productID;
    final outcome = await _verifyPurchaseOnServer(purchase, isUpgrade);
    if (outcome == _VerifyOutcome.transportError) {
      _addLog(
          '⚠️ Verify transport error — leaving transaction unfinished for StoreKit retry');
      return false;
    }
    await _completePurchase(purchase);
    return true;
  }

  Future<void> _completePurchase(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) {
      _addLog('⏭️ No pending complete needed for ${purchase.productID}');
      return;
    }
    try {
      await _inAppPurchase.completePurchase(purchase);
      _addLog('✅ Purchase completed');
    } catch (e) {
      _addLog('❌ Error completing purchase: $e');
    }
  }

  /// Returns how verification ended so callers know whether to finish the txn.
  Future<_VerifyOutcome> _verifyPurchaseOnServer(
      PurchaseDetails purchase, bool isUpgrade) async {
    // Only true when the user tapped buy / change / restore — NOT merely because
    // they opened the edit/subscription screen (stale StoreKit events must not
    // pop, snackbar, or change the selected / active plan).
    final wasUserInitiated = _pendingProductId != null || _isRestoring;
    final onPaywall = SubscriptionScreen.isOnSubscriptionPage;
    final wasAlreadySubscribed = isSubscribed;

    try {
      _addLog('🚀 Verifying on backend...');

      final deviceId = await DeviceInfo.getDeviceId() ?? 'unknown';

      final payload = {
        "product_id": purchase.productID,
        "transaction_id": purchase.purchaseID ?? 'unknown',
        "receipt": purchase.verificationData.serverVerificationData,
        "source": "AppStore",
        "device_id": deviceId,
        "previousProductId": activeProductId,
        "isUpgrade": isUpgrade,
      };

      final newPay = {...payload};
      newPay.remove("receipt");
      debugPrint(newPay.toString());

      final raw = await paymentRepo.updatePaymentPlanNew(payload);
      final result = _normalizeSubscriptionResult(raw);

      final success = result['success'] == true || result['success'] == 'true';
      isSubscribed = result['isActive'] == true || result['isActive'] == 'true';
      _resetPurchaseState();

      _addLog('📥 Success: $success, Active: $isSubscribed');

      if (success && isSubscribed) {
        final String newProductId = purchase.productID;
        final String? oldProductId = activeProductId;

        // Never let a non-user-initiated verify flip the active / selected plan
        // while the user already has a subscription (edit-screen loop).
        final mayUpdatePlan = wasUserInitiated || !wasAlreadySubscribed;
        if (!mayUpdatePlan) {
          _addLog(
              '⏭️ Stale verify — keeping activeProductId=$activeProductId (ignoring $newProductId)');
          return _VerifyOutcome.handled;
        }

        activeProductId = newProductId;
        expiresAt = result['expiresAt']?.toString();
        notifyListeners();

        if (isUpgrade && wasUserInitiated) {
          _addLog('🎉 Subscription upgraded!');
          _addLog('📦 Previous: $oldProductId → New: $newProductId');

          // Pop + success ONLY after an explicit changeSubscription tap.
          if (EditPaymentPlanScreen.isOnSubscriptionChangePage &&
              Navigator.canPop(MyApp.gCtx)) {
            MyApp.gState.pop();
            showCenteredSnackBar();
          }
        } else if (!isUpgrade) {
          _addLog('🎉 Subscription activated!');
          // First-time activation: user buy/restore, or stuck on paywall.
          if (wasUserInitiated || onPaywall) {
            await _ensureNavigatedAfterActivation();
          } else {
            _addLog(
                '⏭️ Active but not user-initiated / not on paywall — skip navigate');
          }
        }

        _addLog('📦 Product: $activeProductId | ⏰ Expires: $expiresAt');
        return _VerifyOutcome.handled;
      } else if (success && !isSubscribed) {
        _addLog('⚠️ Receipt valid but subscription expired.');
        CustomSnackBar.showError(
          message:
              'Your previous subscription has expired. Please choose a plan to continue.',
        );
        _resetPurchaseState();
        return _VerifyOutcome.handled;
      } else {
        _addLog('⚠️ Verification failed. Backend: ${result['message']}');
        final backendMessage = result['message'] as String?;
        CustomSnackBar.showError(
          message: backendMessage?.isNotEmpty == true
              ? backendMessage!
              : 'We could not verify your purchase. Please try again.',
        );
        _resetPurchaseState();
        if (SubscriptionScreen.isOnSubscriptionPage) {
          await _fallbackNavigateIfActive();
        }
        // Backend responded — finish txn to avoid infinite redelivery of a rejected receipt.
        return _VerifyOutcome.handled;
      }
    } catch (e) {
      _addLog('❌ Verification error: $e');
      CustomSnackBar.showError(
        message:
            'We could not verify your purchase. Please contact support if the issue persists.',
      );
      _resetPurchaseState();
      if (SubscriptionScreen.isOnSubscriptionPage) {
        await _fallbackNavigateIfActive();
      }
      return _VerifyOutcome.transportError;
    }
  }

  void showCenteredSnackBar() {
    final screenHeight = MediaQuery.of(MyApp.gCtx).size.height;
    final verticalMargin = screenHeight * 0.30;

    ScaffoldMessenger.of(MyApp.gCtx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 40,
          right: 40,
          bottom: verticalMargin,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        content: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Text(
              "Your plan has been updated!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Navigate now, then re-check after a short delay if still on subscription.
  Future<void> _ensureNavigatedAfterActivation() async {
    await _navigateToHome();

    Future.delayed(const Duration(seconds: 2), () async {
      if (!SubscriptionScreen.isOnSubscriptionPage) return;
      _addLog('⚠️ Still on subscription screen after navigate — running fallback');
      _hasNavigatedToHome = false;
      await _fallbackNavigateIfActive();
    });
  }

  Future<void> _fallbackNavigateIfActive() async {
    try {
      final active = await checkDeviceSubscriptionOnServer();
      if (active &&
          SubscriptionScreen.isOnSubscriptionPage &&
          !_hasNavigatedToHome) {
        _addLog('🏠 Fallback: server active — navigating');
        await _navigateToHome();
      }
    } catch (e) {
      _addLog('❌ Fallback check failed: $e');
    }
  }

  // Keep IAP listener alive — do NOT cancel it here.
  Future<void> _navigateToHome() async {
    if (_hasNavigatedToHome) {
      _addLog('⚠️ Navigation already done, skipping...');
      return;
    }
    _hasNavigatedToHome = true;

    try {
      _addLog('🏠 Navigating to Home...');
      _resetPurchaseState();
      await Future.delayed(const Duration(milliseconds: 300));
      NavigationHelper.navigateAfterAuth();
      _addLog('✅ Navigation complete');
    } catch (e) {
      _addLog('❌ Navigation error: $e');
      // Allow a later retry / fallback to navigate.
      _hasNavigatedToHome = false;
    }
  }

  Future<bool> checkDeviceSubscriptionOnServer() async {
    try {
      _addLog('📡 Checking subscription...');

      final deviceId = await DeviceInfo.getDeviceId() ?? 'unknown';

      final raw =
          await paymentRepo.checkSubscription({"device_id": deviceId});
      final result = _normalizeSubscriptionResult(raw);

      isSubscribed =
          result['isActive'] == true || result['isActive'] == 'true';

      _addLog('📊 Status: ${isSubscribed ? "ACTIVE" : "INACTIVE"}');

      if (result['productId'] != null) {
        activeProductId = result['productId']?.toString();
        _addLog('📦 Product: $activeProductId');
      }

      if (result['expiresAt'] != null) {
        expiresAt = result['expiresAt']?.toString();
        _addLog('⏰ Expires: $expiresAt');
      }

      return isSubscribed;
    } on NetworkException {
      rethrow; // splash catches this to show no-internet overlay
    } catch (e) {
      _addLog('❌ Check failed: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkSubscriptionOnServerAndNavigate() async {
    if (ApiService.userData?.isAdminAllowed == true) {
      NavigationHelper.navigateAfterAuth();
      return;
    }
    final isSubscribed = await checkDeviceSubscriptionOnServer();
    if (isSubscribed) {
      NavigationHelper.navigateAfterAuth();
    } else {
      MyApp.gState.pushNamedAndRemoveUntil(Routes.subscription, (val) => false);
    }
  }

  void _armPurchaseWatchdog() {
    _purchaseWatchdog?.cancel();
    _purchaseWatchdog = Timer(const Duration(minutes: 2), () async {
      if (_pendingProductId == null && !isProcessing) return;
      _addLog('⚠️ Purchase watchdog fired — checking server');
      try {
        final active = await checkDeviceSubscriptionOnServer();
        if (active && SubscriptionScreen.isOnSubscriptionPage) {
          _hasNavigatedToHome = false;
          await _navigateToHome();
          return;
        }
      } catch (_) {}
      if (_pendingProductId != null || isProcessing) {
        CustomSnackBar.showError(
          message:
              'This is taking longer than expected. If you were charged, tap Restore Purchases or reopen the app.',
        );
        _resetPurchaseState();
      }
    });
  }

  void _cancelPurchaseWatchdog() {
    _purchaseWatchdog?.cancel();
    _purchaseWatchdog = null;
  }

  void _resetPurchaseState() {
    _pendingProductId = null;
    _isRestoring = false;
    isProcessing = false;
    _cancelPurchaseWatchdog();
    _restoreTimeoutTimer?.cancel();
    notifyListeners();
  }

  void clearSubscriptionData() {
    isSubscribed = false;
    activeProductId = null;
    expiresAt = null;
    _hasNavigatedToHome = false;
    _pendingProductId = null;
    _isRestoring = false;
    isProcessing = false;
    _processedTransactionIds.clear();
    _cancelPurchaseWatchdog();
    _restoreTimeoutTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _addLog('🧹 Disposing provider...');
    _cancelPurchaseWatchdog();
    _restoreTimeoutTimer?.cancel();
    if (_listenerAttached) {
      _subscription.cancel();
      _listenerAttached = false;
    }
    _addLog('✅ Listener canceled on app close');
    super.dispose();
  }
}

enum _VerifyOutcome { handled, transportError }
