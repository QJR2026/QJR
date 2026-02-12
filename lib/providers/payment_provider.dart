import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/payment_plan.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/routes.dart';
import '/repositories/payment_repository.dart';

import '../utils/custom_snackbar.dart';

class PaymentProvider with ChangeNotifier {
  final _paymentRepo = PaymentRepository();

  int? selectedId;

  setSelectedId(int id) {
    selectedId = id;
    notifyListeners();
  }

  bool getPackagesLoading = false;

  startGetPackagesLoading() {
    getPackagesLoading = true;
    notifyListeners();
  }

  stopGetPackagesLoading() {
    getPackagesLoading = false;
    notifyListeners();
  }

  bool addCardDetailLoading = false;
  startAddCardDetailLoading() {
    addCardDetailLoading = true;
    notifyListeners();
  }

  stopAddCardDetailLoading() {
    addCardDetailLoading = false;
    notifyListeners();
  }

  List<PaymentPlan> paymentPlanList = [];

  Future<void> getAllPackages() async {
    startGetPackagesLoading();
    try {
      selectedId = null;
      paymentPlanList = await _paymentRepo.getAllPackages();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetPackagesLoading();
    }
  }

  Future<void> createPaymentMethod() async {
    // setState(() => _isLoading = true);

    try {
      // startAddCardDetailLoading();
      // // Create Payment Method
      // final paymentMethod = await Stripe.instance.createPaymentMethod(
      //   params: PaymentMethodParams.card(
      //     paymentMethodData: PaymentMethodData(
      //       billingDetails: BillingDetails(
      //         email: ApiService.userData?.email ?? 'example@gmail.com',
      //         name: ApiService.userData?.email.split('@').first ?? 'test',
      //       ),
      //     ),
      //   ),
      // );

      // String paymentMethodId = paymentMethod.id;
      // print("Payment Method ID: $paymentMethodId");

      // // Send Payment Method to Laravel Backend
      // await savePaymentMethodDetail(paymentMethodId);
    } catch (e) {
      print("Error creating Payment Method: $e");
      CustomSnackBar.showError(message: "Error: $e");
    } finally {
      stopAddCardDetailLoading();
    }
  }

  Future<void> savePaymentMethodDetail(String paymentMethodId) async {
    final body = {
      "paymentMethodId": paymentMethodId,
      "package_id": selectedId,
      "auto_renew": 1,
    };
    try {
      startAddCardDetailLoading();
      final response = await _paymentRepo.savePaymentMethodDetail(body);
      if (response != null) {
        ApiService.userData = ApiService.userData
            ?.copyWith(packageId: selectedId?.toString(), isCard: 1);
        if (ApiService.userData?.quotetheme != null &&
            ApiService.userData?.hasPreference == true) {
          MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (val) => false);
        } else {
          MyApp.gState.pushNamedAndRemoveUntil(
              Routes.selectQuoteGroupsTheme, (val) => false);
        }
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopAddCardDetailLoading();
    }
  }

  Future<void> updatePaymentPlan(String paymentMethodId) async {
    startAddCardDetailLoading();
    try {
      // final body = {
      //   "id": selectedId,
      // };
      // final response = await _paymentRepo.updatePaymentPlan(body);
      final body = {
        "paymentMethodId": paymentMethodId,
        "package_id":
            selectedId ?? int.parse(ApiService.userData?.packageId ?? "0"),
        "auto_renew": 1,
      };
      final response = await _paymentRepo.savePaymentMethodDetail(body);
      if (response != null) {
        ApiService.userData =
            ApiService.userData!.copyWith(packageId: selectedId.toString());
        MyApp.gState.pop();
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopAddCardDetailLoading();
    }
  }

  Future<void> updateAutoRenewStatus(int status) async {
    startAddCardDetailLoading();
    try {
      final body = {"auto_renew": status};
      final response = await _paymentRepo.updateAutoRenewStatus(body);
      if (response != null) {
        MyApp.gState.pop();
        MyApp.gState.pop();
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopAddCardDetailLoading();
    }
  }
}
