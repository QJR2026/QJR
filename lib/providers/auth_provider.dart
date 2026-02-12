import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/routes.dart';

import 'package:motivational/app/my_app_view.dart';
import 'package:provider/provider.dart';

import '../repositories/auth_respository.dart';
import '../utils/custom_snackbar.dart';
import '../utils/device_info.dart';
import 'subscription_provider.dart';

class AuthProvider with ChangeNotifier {
  final _authRepo = AuthRepository();

  bool loading = false;
  bool feedBackLoading = false;
  bool reportLoading = false;

  startLoading() {
    loading = true;
    notifyListeners();
  }

  stopLoading() {
    loading = false;
    notifyListeners();
  }

  startFeedbackLoading() {
    feedBackLoading = true;
    notifyListeners();
  }

  stopFeedbackLoading() {
    feedBackLoading = false;
    notifyListeners();
  }

  startReportLoading() {
    reportLoading = true;
    notifyListeners();
  }

  stopReportLoading() {
    reportLoading = false;
    notifyListeners();
  }

  Future<void> signUp({required String email, required String password}) async {
    final String deviceId = await DeviceInfo.getDeviceId() ?? '';
    String token = await getFcmToken();
    startLoading();

    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "password": password,
        "user_type": 0,
        "fcmToken": token,
        "deviceId": deviceId
      };
      await _authRepo.signUp(bodyData);

      await MyApp.gCtx
          .read<SubscriptionProvider>()
          .checkSubscriptionOnServerAndNavigate();

      // MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (a) => false);

      // check from backend if paid then navigate me to pushNamedAndRemoveUntil+selectQuoteGroupsTheme
      //otherwise payment screen

      // MyApp.gState.pushNamedAndRemoveUntil(Routes.subscription, (val) => false);
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<String> getFcmToken() async {
    String fcmToken = '';
    try {
      fcmToken = (await FirebaseMessaging.instance.getToken()) ?? '';
      log('FCM Token: $fcmToken'); // Log the token for debugging
    } catch (e) {
      log('Error getting FCM token: $e');
      fcmToken = 'empty'; // Or handle the error as needed
    }
    return fcmToken;
  }

  Future<void> signin({required String email, required String password}) async {
    final String deviceId = await DeviceInfo.getDeviceId() ?? '';
    String token = await getFcmToken();

    startLoading();

    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "password": password,
        "user_type": 1,
        "fcmToken": token,
        "deviceId": deviceId
      };
      await _authRepo.signin(bodyData);
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> verifyEmail({required String email}) async {
    startLoading();

    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        // "user_type": 0,
      };
      await _authRepo.verifyEmail(bodyData);
      MyApp.gState.pushNamed(
        Routes.otp,
        arguments: email,
      );
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> verifyOTP({required String email, required String otp}) async {
    startLoading();

    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "otp": otp,
        "user_type": 0
      };
      await _authRepo.verifyOTP(bodyData);
      // MyApp.gState.pushNamed(Routes.changePassword, arguments: email);
      MyApp.gState.pushNamed(Routes.resetPassword, arguments: email);
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> forgetPassword(
      {required String email, required String password}) async {
    startLoading();
    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "user_type": 0,
        "password": password
      };
      await _authRepo.forgetPassword(bodyData);
      MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (a) => false);
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> changePassword({
    required String password,
    required String newPassword,
  }) async {
    startLoading();

    try {
      Map<String, dynamic> bodyData = {
        "password": password,
        "new_password": newPassword,
        "id": ApiService.userData?.id ?? ''
      };
      final response = await _authRepo.changePassword(bodyData);
      CustomSnackBar.showSuccess(message: response["message"].toString());
      MyApp.gState.pop();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> feedBack({
    required String feedback,
  }) async {
    startFeedbackLoading();

    try {
      Map<String, dynamic> bodyData = {
        "feedback": feedback,
      };
      final response = await _authRepo.feedback(bodyData);
      CustomSnackBar.showSuccess(message: response["message"].toString());
      MyApp.gState.pop();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopFeedbackLoading();
    }
  }

  Future<void> report({
    required String report,
  }) async {
    startReportLoading();

    try {
      Map<String, dynamic> bodyData = {
        "report": report,
      };
      final response = await _authRepo.report(bodyData);
      CustomSnackBar.showSuccess(message: response["message"].toString());
      MyApp.gState.pop();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopReportLoading();
    }
  }

  Future<void> logout() async {
    startLoading();
    try {
      await _authRepo.logout();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> deleteAccount() async {
    startLoading();
    try {
      await _authRepo.deleteAccount();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }
}
