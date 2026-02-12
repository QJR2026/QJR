import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/constants/api_end_points.dart';
import 'package:motivational/providers/subscription_provider.dart';
import 'package:provider/provider.dart';

import '../model/user_data.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';
import '../utils/error_handler.dart';
import '../utils/routes.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final SharedPreferencesService _sharedPreferences =
      SharedPreferencesService();
  Future<dynamic> signUp(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.signUp, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = response.data["data"]["access_token"];
        // _sharedPreferences.setString("token", token);
        // _sharedPreferences.setString(
        //     "data", jsonEncode(response.data["data"]['data']));
        ApiService.authToken = token;
        ApiService.userData = UserData.fromJson(
            response.data["data"]['data'] as Map<String, dynamic>);

        return response.data["data"];
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> signin(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.login, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String token = response.data["data"]["access_token"];
        ApiService.authToken = token;
        final Map<String, dynamic> userDataMap =
            response.data["data"]['data'] as Map<String, dynamic>;

        ApiService.userData = UserData.fromJson(userDataMap);
        String routeName = Routes.home;

        if (ApiService.userData!.userType == "1") {
          await _sharedPreferences.setString("token", token);
          await _sharedPreferences.setString("data", jsonEncode(userDataMap));

          routeName = Routes.adminBaseScreen;
        } else {
          // if ((ApiService.userData?.isCardAdded ?? false) == false) {
          //   routeName = Routes.paymentMethod;
          // } else

          final isSubscribed = await MyApp.gCtx
              .read<SubscriptionProvider>()
              .checkDeviceSubscriptionOnServer();
          // changes v1
          if (!isSubscribed) {
            routeName = Routes.subscription;
          } else {
            if ((ApiService.userData?.isThemeSelected ?? false) == false) {
              routeName = Routes.selectQuoteGroupsTheme;
            } else if ((ApiService.userData?.hasPreference ?? false) == false) {
              routeName = Routes.selectNotificationTimePref;
            } else {
              await _sharedPreferences.setString(
                  "data", jsonEncode(userDataMap));
              await _sharedPreferences.setString("token", token);
              routeName = Routes.home;
            }
          }
        }

        MyApp.gState.pushNamedAndRemoveUntil(
          routeName,
          (route) => false,
          arguments: ApiService.userData?.quotetheme,
        );

        return response.data["data"];
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      debugPrint("Signin Error: $error\nStackTrace: $stackTrace");
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> verifyEmail(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.verifyEmail, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["data"];
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> verifyOTP(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.verifyOtp, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["data"];
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

// //change password unauth
  Future<dynamic> forgetPassword(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.patch(ApiEndpoints.forgetPassword, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["data"];
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

//   //reset password auth
  Future<dynamic> changePassword(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.patch(ApiEndpoints.changePassword, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> feedback(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.feedBack, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> report(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.report, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<void> clearPreferences() async {
    final keys = _sharedPreferences.getKeys();
    for (String key in keys) {
      if (key != 'onboarding') {
        await _sharedPreferences.remove(key);
      }
    }
  }

  Future<dynamic> logout() async {
    try {
      final response = await _apiService.post(ApiEndpoints.logout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearPreferences();
        await _sharedPreferences.setString("onboarding", "1");

        ApiService.userData = null;
        ApiService.authToken = null;
        MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (a) => false);
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<dynamic> deleteAccount() async {
    try {
      final response = await _apiService.delete(ApiEndpoints.deletAccount);

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearPreferences();
        await _sharedPreferences.setString("onboarding", "1");
        ApiService.userData = null;
        ApiService.authToken = null;
        MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (a) => false);
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  Future<UserData> getUser() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getUser);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserData.fromJson(response.data["data"]);
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }
}
