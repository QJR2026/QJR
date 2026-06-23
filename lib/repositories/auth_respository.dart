import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/constants/api_end_points.dart';

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

  Future<void> signin(Map<String, dynamic> bodyData) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.login, data: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ApiService.authToken =
            response.data["data"]["access_token"] as String;
        ApiService.userData = UserData.fromJson(
          response.data["data"]['data'] as Map<String, dynamic>,
        );
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
