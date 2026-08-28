import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/routes.dart';

import 'package:motivational/app/my_app_view.dart';
import 'package:provider/provider.dart';

import '../repositories/auth_respository.dart';
import '../services/shared_prefrence_service.dart';
import '../utils/custom_snackbar.dart';
import '../utils/device_info.dart';
import '../utils/navigation_helper.dart';
import 'subscription_provider.dart';
import 'theme_provider.dart';

class AuthProvider with ChangeNotifier {
  final _authRepo = AuthRepository();
  final _sharedPreferences = SharedPreferencesService();

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

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final subscriptionProvider = MyApp.gCtx.read<SubscriptionProvider>();
    final String deviceId = await DeviceInfo.getDeviceId() ?? '';
    final String fcmToken = await getFcmToken();
    startLoading();

    try {
      await _authRepo.signUp({
        "fullName": fullName,
        "email": email,
        "password": password,
        "user_type": 0,
        "fcmToken": fcmToken,
        "deviceId": deviceId,
      });

      await subscriptionProvider.checkSubscriptionOnServerAndNavigate();
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
    final subscriptionProvider = MyApp.gCtx.read<SubscriptionProvider>();
    final String deviceId = await DeviceInfo.getDeviceId() ?? '';
    final String fcmToken = await getFcmToken();

    startLoading();

    try {
      await _authRepo.signin({
        "email": email,
        "password": password,
        "user_type": 1,
        "fcmToken": fcmToken,
        "deviceId": deviceId,
      });

      final userData = ApiService.userData!;

      if (userData.userType == "1") {
        await _sharedPreferences.setString("token", ApiService.authToken ?? '');
        await _sharedPreferences.setString(
            "data", jsonEncode(userData.toJson()));
        MyApp.gState
            .pushNamedAndRemoveUntil(Routes.adminBaseScreen, (_) => false);
      } else {
        bool canProceed = userData.isAdminAllowed;
        if (!canProceed) {
          canProceed =
              await subscriptionProvider.checkDeviceSubscriptionOnServer();
        }
        if (canProceed) {
          NavigationHelper.navigateAfterAuth();
        } else {
          MyApp.gState
              .pushNamedAndRemoveUntil(Routes.subscription, (_) => false);
        }
      }
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

  Future<void> resendOTP({required String email}) async {
    startLoading();
    try {
      await _authRepo.verifyEmail({"email": email});
      CustomSnackBar.showSuccess(message: 'OTP resent successfully.');
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
      CustomSnackBar.showPrimary(message: response["message"].toString());
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
      MyApp.gCtx.read<ThemeProvider>().resetQuoteThemes();
      MyApp.gCtx.read<SubscriptionProvider>().clearSubscriptionData();
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
      MyApp.gCtx.read<ThemeProvider>().resetQuoteThemes();
      MyApp.gCtx.read<SubscriptionProvider>().clearSubscriptionData();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }
}
