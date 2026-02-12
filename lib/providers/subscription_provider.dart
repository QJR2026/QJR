// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:motivational/repositories/subscription_repository.dart';

// class SubscriptionProvider extends ChangeNotifier {
//   final _subscriptionRepo = SubscriptionRepository();
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late final StreamSubscription<List<PurchaseDetails>> _subscription;

//   bool isAvailable = false;
//   bool isLoading = true; // Used for initial store info loading
//   bool isProcessing =
//       false; // Used for buy/restore actions to prevent double-tap
//   bool isSubscribed = false;

//   List<ProductDetails> products = [];
//   List<PurchaseDetails> purchases = [];

//   static const Set<String> _kIds = {'monthly_plan', 'yearly_plan'};

//   // 👇 Logging support
//   String _log = '';
//   String get log => _log;

//   void _addLog(String message) {
//     final timestamp =
//         DateTime.now().toIso8601String().split('T').last.split('.').first;
//     _log += '[$timestamp] $message\n';
//     notifyListeners();
//     // Using print/debugPrint here for console visibility
//     if (kDebugMode) {
//       debugPrint('LOG: $message');
//     }
//   }

//   clearLog() {
//     _log = "";
//     notifyListeners();
//   }

//   SubscriptionProvider() {
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     _addLog('🟢 Initializing SubscriptionProvider...');

//     final purchaseUpdated = _inAppPurchase.purchaseStream;

//     _subscription = purchaseUpdated.listen(
//       _handlePurchaseUpdates,
//       onError: (error) {
//         _addLog('❌ Purchase stream error: $error');
//       },
//       onDone: () => _addLog('ℹ️ Purchase stream closed'),
//     );

//     await _initStoreInfo();
//   }

//   Future<void> _initStoreInfo() async {
//     try {
//       isLoading = true;
//       notifyListeners();

//       isAvailable = await _inAppPurchase.isAvailable();
//       _addLog('Store available: $isAvailable');

//       if (!isAvailable) {
//         _addLog(
//             '⚠️ Store is not available. Check internet or App Store setup.');
//         return;
//       }

//       final response = await _inAppPurchase.queryProductDetails(_kIds);

//       if (response.error != null) {
//         _addLog('❌ Product query error: ${response.error}');
//       }

//       if (response.productDetails.isEmpty) {
//         _addLog(
//             '⚠️ No products found. Check product IDs or App Store Connect setup.');
//       }

//       products = response.productDetails;
//       _addLog('✅ Loaded products: ${products.map((e) => e.id).join(', ')}');
//     } catch (e) {
//       _addLog('❌ Error initializing store info: $e');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Buy logic
//   Future<void> buy(ProductDetails product) async {
//     if (isProcessing) {
//       _addLog(
//           '⚠️ Already processing an action. Skipping buy attempt for ${product.id}.');
//       return;
//     }

//     try {
//       isProcessing = true; // Start processing
//       notifyListeners();

//       _addLog('🛒 Attempting to buy: ${product.id}');
//       final purchaseParam = PurchaseParam(productDetails: product);

//       final bool success =
//           await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

//       if (!success) {
//         _addLog(
//             '⚠️ Platform failed to launch purchase flow or was canceled immediately.');
//         isProcessing =
//             false; // If platform launch fails immediately, reset state
//         notifyListeners();
//       }
//       // Note: If success is true, isProcessing remains true until the stream handles a final status.
//     } catch (e) {
//       _addLog('❌ Buy error: $e');
//       isProcessing = false; // Error, stop processing
//       notifyListeners();
//     }
//   }

//   // Restore logic
//   Future<void> restorePurchases() async {
//     if (isProcessing) {
//       _addLog('⚠️ Already processing an action. Skipping restore attempt.');
//       return;
//     }

//     try {
//       isProcessing = true; // Start processing
//       notifyListeners();

//       _addLog('🔄 Restoring previous purchases...');
//       await _inAppPurchase.restorePurchases();
//       // Wait for the stream listener to handle the final result.
//     } catch (e) {
//       _addLog('❌ Restore error: $e');
//       isProcessing = false; // Error, stop processing
//       notifyListeners();
//     }
//   }

//   // ** UPDATED: Purchase handler **
//   Future<void> _handlePurchaseUpdates(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     // Flag to check if any purchase reached a terminal state (purchased, error, restored, canceled)
//     bool purchaseFinalized = false;

//     if (purchaseDetailsList.isEmpty) {
//       _addLog('ℹ️ No purchase updates received.');
//       // If we are currently processing a buy/restore, this might be temporary.
//       return;
//     }

//     for (final purchase in purchaseDetailsList) {

//       _addLog('📦 Purchase update: ${purchase.productID} | ${purchase.status}');

//       if (Platform.isIOS && purchase.pendingCompletePurchase) {
//         await _inAppPurchase.completePurchase(purchase);
//       }

//       switch (purchase.status) {
//         case PurchaseStatus.purchased:
//           _addLog('✅ Purchase completed successfully. Validating receipt...');
//           _logPurchaseDetails(purchase); // Logs receipt data

//           bool validationSuccess = false;
//           try {
//             // 1. Send data to backend for validation
//             await _subscriptionRepo.validateReciept({
//               "receipt": purchase.verificationData.serverVerificationData,
//               "package_id": purchase.productID
//             });
//             validationSuccess = true;
//             _addLog('🚀 Receipt validated successfully on server.');
//           } catch (ex) {
//             _addLog('❌ Server validation FAILED: ${ex.toString()}');
//             // If server validation fails, DO NOT call completePurchase.
//             // The transaction remains in the queue and will be retried later.
//           }

//           if (validationSuccess) {
//             // 2. Grant entitlement locally
//             isSubscribed = true;

//             // 3. **CRITICAL FIX**: Complete purchase to finalize the transaction in the store queue.
//             await _inAppPurchase.completePurchase(purchase);
//             _addLog('🎉 Transaction finalized with store (completePurchase).');
//           }
//           purchaseFinalized = true; // The status reached a terminal state
//           break;

//         case PurchaseStatus.restored:
//           _addLog('♻️ Purchase restored. Granting entitlement.');
//           _logPurchaseDetails(purchase);

//           // NOTE: For restored purchases, you MUST also complete the purchase
//           // to clear the restored transaction from the queue.
//           await _inAppPurchase.completePurchase(purchase);
//           _addLog('🎉 Restored transaction finalized.');

//           isSubscribed = true;
//           purchaseFinalized = true;
//           break;

//         case PurchaseStatus.error:
//           _addLog('❌ Purchase error: ${purchase.error}');
//           if (purchase.error?.message.contains('cancelled') ?? false) {
//             _addLog('🚫 Purchase was cancelled by the user.');
//           }

//           // Complete the purchase to clear the error/canceled transaction from the queue.
//           if (purchase.pendingCompletePurchase) {
//             await _inAppPurchase.completePurchase(purchase);
//             _addLog('🧹 Completed pending error cleanup.');
//           }

//           purchaseFinalized = true;
//           break;

//         case PurchaseStatus.pending:
//           _addLog('⏳ Purchase is pending... waiting for confirmation.');
//           // Do not set finalized, keep processing state active
//           break;

//         case PurchaseStatus.canceled:
//           _addLog(
//               '🚫 Purchase canceled (StoreKit iOS 17+ may use this status).');
//           purchaseFinalized = true;
//           break;

//         default:
//           _addLog('⚠️ Unknown purchase status: ${purchase.status}');
//           purchaseFinalized = true;
//       }

//       // Removed the generic `if (purchase.pendingCompletePurchase)` cleanup
//       // from here and incorporated it into the specific cases for better flow control.
//     }

//     purchases = purchaseDetailsList;

//     // Final state reset: If any purchase flow concluded (purchased, error, etc.),
//     // we reset the action processing flag.
//     if (purchaseFinalized) {
//       isProcessing = false;
//     }

//     notifyListeners();
//   }

//   void _logPurchaseDetails(PurchaseDetails purchase) {
//     final verificationData = purchase.verificationData;
//     final serverReceipt = verificationData.serverVerificationData;
//     final localReceipt = verificationData.localVerificationData;
//     final source = verificationData.source;

//     final info = '''
// 🧾 PURCHASE INFO:
// - Product ID: ${purchase.productID}
// - Purchase ID: ${purchase.purchaseID ?? 'N/A'}
// - Transaction Date: ${purchase.transactionDate ?? 'N/A'}
// - Source: $source
// -----------------------------------------
//    Server Verification Data (Receipt):
//       $serverReceipt
//    Local Verification Data:
//       $localReceipt
// -----------------------------------------
// ''';
//     _addLog(info);
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     _addLog('🧹 SubscriptionProvider disposed.');
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/repositories/payment_repository.dart';

import '../services/api_service.dart';
import '../utils/device_info.dart';
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

  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  // Subscription data
  String? activeProductId;
  String? expiresAt;

  final List<String> logs = [];
  final Set<String> _processedTransactionIds = {};
  String? _pendingProductId;

  bool _hasNavigatedToHome = false;

  // Product IDs
  static const String kMonthlyProductId = 'monthly_plan';
  static const String kYearlyProductId = 'yearly_plan';
  static const Set<String> _kIds = {kMonthlyProductId, kYearlyProductId};

  // Backend endpoints
  // static const String _baseUrl =
  //     'https://us-central1-sow-easy.cloudfunctions.net';
  // static const String _validateReceiptEndpoint = '$_baseUrl/validateReceipt';
  // static const String _checkSubscriptionEndpoint =
  //     '$_baseUrl/checkDeviceSubscription';

  final paymentRepo = PaymentRepository();

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final logEntry = "[$timestamp] $message";
    if (kDebugMode) print("🟢 IAP: $logEntry");
    logs.insert(0, logEntry);
    notifyListeners();
  }

  /// Initialize subscription system - CALL ONLY ONCE in main.dart
  Future<void> initialize() async {
    if (_isInitialized) {
      _addLog('⚠️ Already initialized, skipping...');
      return;
    }

    _addLog('Initializing In-App Purchase...');

    try {
      // Clear stale transactions before listener setup
      await _clearPendingTransactions();

      // Setup purchase stream listener (ONLY ONCE)
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) => _addLog('❌ Purchase stream error: $error'),
        onDone: () => _addLog('✅ Purchase stream closed'),
      );

      _addLog('✅ Purchase stream listener attached');

      // Load products
      await initStoreInfo();

      // Check previous subscription
      if (isAvailable) {
        _addLog('Store available — checking previous purchases...');
        await checkDeviceSubscriptionOnServer();
      }

      _isInitialized = true;
    } catch (e) {
      _addLog('❌ Initialization error: $e');
    }
  }

  /// Refresh product list - SAFE to call multiple times from any page
  Future<void> initStoreInfo() async {
    try {
      if (products.isNotEmpty) return;
      isLoading = true;
      notifyListeners();

      isAvailable = await _inAppPurchase.isAvailable();
      _addLog('Store available: $isAvailable');

      if (!isAvailable) return;

      final response = await _inAppPurchase.queryProductDetails(_kIds);

      if (response.error != null) {
        _addLog('❌ Product query error: ${response.error}');
        return;
      }

      if (response.productDetails.isEmpty) {
        _addLog('⚠️ No products found for IDs: $_kIds');
        return;
      }

      products = response.productDetails;
      isLoading = false;
      notifyListeners();
      _addLog('✅ Products fetched: ${products.map((p) => p.id).join(", ")}');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _addLog('❌ _initStoreInfo error: $e');
    }
  }

  /// Get the active subscription plan details
  ProductDetails? get activePlan {
    if (activeProductId == null || products.isEmpty) return null;
    try {
      return products.firstWhere((val) => val.id == activeProductId);
    } catch (e) {
      return null;
    }
  }

  /// Get the other subscription plan (for upgrade/downgrade)
  ProductDetails? get otherThanActivePlan {
    if (activeProductId == null || products.isEmpty) return null;
    try {
      return products.firstWhere((val) => val.id != activeProductId);
    } catch (e) {
      return null;
    }
  }

  /// Clear pending transactions from the payment queue
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
          _processedTransactionIds.add(transaction.transactionIdentifier!);
          _addLog('✅ Finished: ${transaction.transactionIdentifier}');
        } catch (e) {
          _addLog('⚠️ Error finishing transaction: $e');
        }
      }
    } catch (e) {
      _addLog('❌ Error clearing transactions: $e');
    }
  }

  /// Purchase a product (new subscription)
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
    isProcessing = true;
    isLoading = true;
    notifyListeners();

    try {
      _addLog('💰 Starting purchase: ${product.id}');
      await _clearPendingTransactions();

      final param = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: param);

      _addLog('✅ Purchase request sent to store');
    } catch (e) {
      _addLog('❌ Purchase error: $e');
      _resetPurchaseState();
    }
  }

  /// Upgrade or downgrade existing subscription
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
    isLoading = true;
    notifyListeners();

    try {
      _addLog('🔄 Changing subscription: $activeProductId → ${newProduct.id}');
      await _clearPendingTransactions();

      final param = PurchaseParam(productDetails: newProduct);
      await _inAppPurchase.buyNonConsumable(purchaseParam: param);

      _addLog('✅ Subscription change request sent to store');
    } catch (e) {
      _addLog('❌ Change subscription error: $e');
      _resetPurchaseState();
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (isProcessing) return;

    try {
      _addLog('♻️ Restoring purchases...');
      isProcessing = true;
      notifyListeners();

      await _clearPendingTransactions();
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _addLog('❌ Restore error: $e');
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }

  /// Handle incoming purchase updates
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> list) async {
    _addLog('🔄 Purchase updates: ${list.length}');
    purchases = list;

    for (final purchase in list) {
      final purchaseId = purchase.purchaseID ?? 'unknown';

      // Check if this is the product we're waiting for (upgrade/downgrade)
      final isExpectedChange =
          _pendingProductId != null && purchase.productID == _pendingProductId;

      // Skip already processed transactions UNLESS it's an expected change
      if (_processedTransactionIds.contains(purchaseId) && !isExpectedChange) {
        _addLog('⏭️ Skipping already processed: $purchaseId');
        continue;
      }

      // If we're expecting this change, allow reprocessing
      if (isExpectedChange) {
        _addLog(
            '🔄 Processing expected upgrade/downgrade: ${purchase.productID}');
        _processedTransactionIds
            .remove(purchaseId); // Remove to allow reprocessing
      }

      // Skip if it's the current subscription and no pending change
      if (isSubscribed &&
          activeProductId == purchase.productID &&
          _pendingProductId == null) {
        _addLog('⏭️ Skipping: already subscribed to ${purchase.productID}');
        _processedTransactionIds.add(purchaseId);
        continue;
      }

      _addLog('🧾 ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchase);
          _processedTransactionIds.add(purchaseId);
          break;

        case PurchaseStatus.error:
          _addLog('❌ Error: ${purchase.error?.message}');
          _processedTransactionIds.add(purchaseId);
          await _completePurchase(purchase);
          _resetPurchaseState();
          break;

        case PurchaseStatus.canceled:
          _addLog('⚠️ Purchase canceled');
          _processedTransactionIds.add(purchaseId);
          await _completePurchase(purchase);
          _resetPurchaseState();
          break;

        case PurchaseStatus.pending:
          _addLog('⏳ Pending...');
          break;
      }
    }
  }

  /// Handle successful purchase
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    _addLog('✅ Purchase successful: ${purchase.productID}');

    final isUpgrade = isSubscribed && activeProductId != purchase.productID;
    await _verifyPurchaseOnServer(purchase, isUpgrade);
    await _completePurchase(purchase);
  }

  /// Complete a purchase with error handling
  Future<void> _completePurchase(PurchaseDetails purchase) async {
    try {
      await _inAppPurchase.completePurchase(purchase);
      _addLog('✅ Purchase completed');
    } catch (e) {
      _addLog('❌ Error completing purchase: $e');
    }
  }

  /// Verify receipt on backend
  Future<void> _verifyPurchaseOnServer(
      PurchaseDetails purchase, bool isUpgrade) async {
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

      // final callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      //   _validateReceiptEndpoint,
      // );

      // final result = await callable.call(payload);

      final result = await paymentRepo.updatePaymentPlanNew(payload);

      isSubscribed = result['isActive'] ?? false;
      _resetPurchaseState();

      _addLog('📥 Success: ${result['success']}, Active: $isSubscribed');

      if (result['success'] == true && isSubscribed) {
        // ✅ CRITICAL FIX: Always use the purchase's productID, not backend response
        // The backend might return stale data during upgrades
        final String newProductId = purchase.productID;
        final String? oldProductId = activeProductId;

        // Update local state with NEW product
        activeProductId = newProductId;
        expiresAt = result['expiresAt'];

        if (isUpgrade) {
          _addLog('🎉 Subscription upgraded!');
          _addLog('📦 Previous: $oldProductId → New: $newProductId');

          // Just pop the dialog, don't navigate
          if (EditPaymentPlanScreen.isOnSubscriptionChangePage &&
              Navigator.canPop(MyApp.gCtx)) {
            _resetPurchaseState();
            MyApp.gState.pop();
            showCenteredSnackBar();
          }
        } else {
          _addLog('🎉 Subscription activated!');
          // Navigate only on initial purchase
          if (SubscriptionScreen.isOnSubscriptionPage) await _navigateToHome();
        }

        _addLog('📦 Product: $activeProductId | ⏰ Expires: $expiresAt');
      } else {
        _addLog('⚠️ Subscription not active. Backend: ${result['message']}');
        _resetPurchaseState();
      }
    } catch (e) {
      _addLog('❌ Verification error: $e');
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

  /// Navigate to home - KEEP LISTENER ALIVE
  /// ✅ FIX: Do NOT cancel the subscription listener here
  /// The listener needs to stay active for subscription changes later
  Future<void> _navigateToHome() async {
    if (_hasNavigatedToHome) {
      _addLog('⚠️ Navigation already done, skipping...');
      return;
    }
    _hasNavigatedToHome = true;

    try {
      _addLog('🏠 Navigating to Home...');
      _resetPurchaseState();

      // ✅ IMPORTANT: Do NOT cancel the listener here
      // await _subscription.cancel();  // ❌ DELETE THIS - keeps listener alive

      await Future.delayed(const Duration(milliseconds: 300));

      // MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (val) => false);
      navigateAccordingData();

      _addLog('✅ Navigation complete (listener still active for changes)');
    } catch (e) {
      _addLog('❌ Navigation error: $e');
    }
  }

  /// Check device subscription status
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
    } catch (e) {
      _addLog('❌ Check failed: $e');
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Check subscription and navigate
  Future<void> checkSubscriptionOnServerAndNavigate() async {
    final isSubscribedd = await checkDeviceSubscriptionOnServer();
    // changes
    if (isSubscribedd) {
      navigateAccordingData();
    } else {
      MyApp.gState.pushNamedAndRemoveUntil(Routes.subscription, (val) => false);
    }
  }

  navigateAccordingData() {
    if (ApiService.userData?.quotetheme != null &&
        ApiService.userData?.hasPreference == true) {
      MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (val) => false);
    } else if (ApiService.userData?.quotetheme == null) {
      MyApp.gState.pushNamedAndRemoveUntil(
          Routes.selectQuoteGroupsTheme, (val) => false);
    } else if (ApiService.userData?.hasPreference == true) {
      MyApp.gState.pushNamedAndRemoveUntil(
          Routes.selectNotificationTimePref, (val) => false);
    }
  }

  void _resetPurchaseState() {
    _pendingProductId = null;
    isProcessing = false;
    isLoading = false;
    notifyListeners();
  }

  /// Clear subscription data (for logout or cancellation)
  void clearSubscriptionData() {
    isSubscribed = false;
    activeProductId = null;
    expiresAt = null;
    _hasNavigatedToHome = false;
    notifyListeners();
  }

  /// ✅ IMPORTANT: Only cancel listener when app is fully closing
  @override
  void dispose() {
    _addLog('🧹 Disposing provider...');
    _subscription.cancel();
    _addLog('✅ Listener canceled on app close');
    super.dispose();
  }
}
