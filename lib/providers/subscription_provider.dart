import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  Future<void> initialize() async {
    if (_isInitialized) {
      _addLog('⚠️ Already initialized, skipping...');
      return;
    }

    _addLog('Initializing In-App Purchase...');

    try {
      await _clearPendingTransactions();

      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) => _addLog('❌ Purchase stream error: $error'),
        onDone: () => _addLog('✅ Purchase stream closed'),
      );

      _addLog('✅ Purchase stream listener attached');

      await initStoreInfo();

      if (isAvailable) {
        _addLog('Store available — checking previous purchases...');
        await checkDeviceSubscriptionOnServer();
      }

      _isInitialized = true;
    } catch (e) {
      _addLog('❌ Initialization error: $e');
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
      // isLoading = false;
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

  Future<void> _clearPendingTransactions() async {
    try {
      _addLog('🧹 Clearing pending transactions...');
      final wrapper = SKPaymentQueueWrapper();
      final transactions = await wrapper.transactions();

      if (transactions.isEmpty) {
        _addLog('✅ No pending transactions');
        return;
      }

      _addLog('Found ${transactions.length} transaction(s)');

      for (final transaction in transactions) {
        try {
          await wrapper.finishTransaction(transaction);
          _addToProcessed(transaction.transactionIdentifier!);
          _addLog('✅ Finished: ${transaction.transactionIdentifier}');
        } catch (e) {
          _addLog('⚠️ Error finishing transaction: $e');
        }
      }
    } catch (e) {
      _addLog('❌ Error clearing transactions: $e');
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

    try {
      _addLog('💰 Starting purchase: ${product.id}');
      await _clearPendingTransactions();

      // A purchasing transaction can't be finished while still in-flight.
      // If the product is still in the queue after clearing, don't add a
      // duplicate — the existing stream event will deliver the result.
      final remaining = await SKPaymentQueueWrapper().transactions();
      if (remaining.any((t) => t.payment.productIdentifier == product.id)) {
        _addLog('⏳ Already in StoreKit queue — waiting for existing transaction');
        return;
      }

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
    } catch (e) {
      _addLog('❌ Purchase error: $e');
      CustomSnackBar.showError(message: 'Something went wrong with your purchase. Please try again.');
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
    isProcessing = true;
    notifyListeners();

    try {
      _addLog('🔄 Changing subscription: $activeProductId → ${newProduct.id}');
      await _clearPendingTransactions();

      final remaining = await SKPaymentQueueWrapper().transactions();
      if (remaining.any((t) => t.payment.productIdentifier == newProduct.id)) {
        _addLog('⏳ Already in StoreKit queue — waiting for existing transaction');
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
    } catch (e) {
      _addLog('❌ Change subscription error: $e');
      CustomSnackBar.showError(message: 'Something went wrong. Please try again.');
      _resetPurchaseState();
    }
  }

  Future<void> restorePurchases() async {
    if (isProcessing) return;

    try {
      _addLog('♻️ Restoring purchases...');
      isProcessing = true;
      _isRestoring = true;
      notifyListeners();

      await _clearPendingTransactions();
      await _inAppPurchase.restorePurchases();
      // _isRestoring stays true — StoreKit delivers restored events
      // asynchronously via the purchase stream after this returns.
      // Fallback: if no restored events arrive within 15 s (nothing to restore),
      // clear the flag so it doesn't leak.
      Future.delayed(const Duration(seconds: 15), () {
        if (_isRestoring) {
          _isRestoring = false;
          _addLog('⚠️ Restore timed out — no purchases found');
          CustomSnackBar.showError(message: 'No previous purchases found to restore.');
          notifyListeners();
        }
      });
    } catch (e) {
      _addLog('❌ Restore error: $e');
      _isRestoring = false;
      CustomSnackBar.showError(message: 'Failed to restore purchases. Please try again.');
    } finally {
      isProcessing = false;
      notifyListeners();
    }
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
        continue;
      }

      if (isExpectedChange) {
        _addLog(
            '🔄 Processing expected upgrade/downgrade: ${purchase.productID}');
        _processedTransactionIds.remove(purchaseId);
      }

      if (isSubscribed &&
          activeProductId == purchase.productID &&
          _pendingProductId == null) {
        _addLog('⏭️ Skipping: already subscribed to ${purchase.productID}');
        _addToProcessed(purchaseId);
        continue;
      }

      _addLog('🧾 ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          if (_pendingProductId != null) {
            await _handleSuccessfulPurchase(purchase);
          } else {
            // Stale re-delivery from a previous session — the server already
            // has the correct state. Just finish the transaction so StoreKit
            // stops re-delivering it; never re-verify on the backend.
            _addLog('⏭️ Finishing stale transaction: ${purchase.productID}');
            await _completePurchase(purchase);
          }
          _addToProcessed(purchaseId);
          break;

        case PurchaseStatus.restored:
          // Only arrives from an explicit restorePurchases() call — always process.
          await _handleSuccessfulPurchase(purchase);
          _addToProcessed(purchaseId);
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
          _addLog('⏳ Pending...');
          break;
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    _addLog('✅ Purchase successful: ${purchase.productID}');

    final isUpgrade = isSubscribed && activeProductId != purchase.productID;
    await _verifyPurchaseOnServer(purchase, isUpgrade);
    await _completePurchase(purchase);
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

  Future<void> _verifyPurchaseOnServer(
      PurchaseDetails purchase, bool isUpgrade) async {
    // Capture before any await or reset — stale StoreKit re-deliveries arrive
    // with _pendingProductId == null because the user didn't initiate them.
    final wasUserInitiated = _pendingProductId != null || _isRestoring;

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

      final result = await paymentRepo.updatePaymentPlanNew(payload);

      isSubscribed = result['isActive'] ?? false;
      _resetPurchaseState();

      _addLog('📥 Success: ${result['success']}, Active: $isSubscribed');

      if (result['success'] == true && isSubscribed) {
        final String newProductId = purchase.productID;
        final String? oldProductId = activeProductId;

        activeProductId = newProductId;
        expiresAt = result['expiresAt'];

        if (isUpgrade) {
          _addLog('🎉 Subscription upgraded!');
          _addLog('📦 Previous: $oldProductId → New: $newProductId');

          if (wasUserInitiated &&
              EditPaymentPlanScreen.isOnSubscriptionChangePage &&
              Navigator.canPop(MyApp.gCtx)) {
            _resetPurchaseState();
            MyApp.gState.pop();
            showCenteredSnackBar();
          }
        } else {
          _addLog('🎉 Subscription activated!');
          if (wasUserInitiated) await _navigateToHome();
        }

        _addLog('📦 Product: $activeProductId | ⏰ Expires: $expiresAt');
      } else if (result['success'] == true && !isSubscribed) {
        // Backend verified the receipt but the subscription is no longer active
        // (expired). Show a friendly message — never show the backend's internal
        // success string as a red error.
        _addLog('⚠️ Receipt valid but subscription expired.');
        CustomSnackBar.showError(
          message: 'Your previous subscription has expired. Please choose a plan to continue.',
        );
        _resetPurchaseState();
      } else {
        _addLog('⚠️ Verification failed. Backend: ${result['message']}');
        final backendMessage = result['message'] as String?;
        CustomSnackBar.showError(
          message: backendMessage?.isNotEmpty == true
              ? backendMessage!
              : 'We could not verify your purchase. Please try again.',
        );
        _resetPurchaseState();
      }
    } catch (e) {
      _addLog('❌ Verification error: $e');
      CustomSnackBar.showError(
        message: 'We could not verify your purchase. Please contact support if the issue persists.',
      );
      _resetPurchaseState();
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
    }
  }

  Future<bool> checkDeviceSubscriptionOnServer() async {
    try {
      _addLog('📡 Checking subscription...');

      final deviceId = await DeviceInfo.getDeviceId() ?? 'unknown';

      final result =
          await paymentRepo.checkSubscription({"device_id": deviceId});

      isSubscribed = result['isActive'] ?? false;

      _addLog('📊 Status: ${isSubscribed ? "ACTIVE" : "INACTIVE"}');

      if (result['productId'] != null) {
        activeProductId = result['productId'];
        _addLog('📦 Product: $activeProductId');
      }

      if (result['expiresAt'] != null) {
        expiresAt = result['expiresAt'];
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

  void _resetPurchaseState() {
    _pendingProductId = null;
    _isRestoring = false;
    isProcessing = false;
    notifyListeners();
  }

  void clearSubscriptionData() {
    isSubscribed = false;
    activeProductId = null;
    expiresAt = null;
    _hasNavigatedToHome = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _addLog('🧹 Disposing provider...');
    _subscription.cancel();
    _addLog('✅ Listener canceled on app close');
    super.dispose();
  }
}
