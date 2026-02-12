import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:motivational/model/preference.dart';

import '../constants/api_end_points.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';
import '../utils/error_handler.dart';

class NotificationTimePreferenceRepository {
  final ApiService _apiService = ApiService();
  final SharedPreferencesService _sharedPreferences =
      SharedPreferencesService();
  Future<dynamic> saveDaysAndTimePrefrenceForNotication(
      Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.preference, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (ApiService.authToken != null) {
          _sharedPreferences.setString("token", ApiService.authToken ?? '');
        }
        if (ApiService.userData != null) {
          ApiService.userData =
              ApiService.userData?.copyWith(hasPreference: true);
          _sharedPreferences.setString("data", jsonEncode(ApiService.userData));
        }
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

  Future<dynamic> saveThemeAndTimePrefrence(Map<String, dynamic> body) async {
    try {
      final response = await _apiService
          .patch(ApiEndpoints.saveThemeAndTimePrefrence, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // if (ApiService.authToken != null) {
        //   _sharedPreferences.setString("token", ApiService.authToken ?? '');
        // }
        // if (ApiService.userData != null) {
        //   ApiService.userData =
        //       ApiService.userData?.copyWith(hasPreference: true);
        //   _sharedPreferences.setString("data", jsonEncode(ApiService.userData));
        // }
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

  Future<Preference?> getPrefrenceForNotication() async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.getPreference(
            ApiService.userData?.quotetheme?.id.toString() ?? ''),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Preference.fromJson(response.data["data"]);
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404 &&
            error.response?.data["message"] == 'User preference not found.') {
          ApiService.userData!.quotetheme = null;
        }
      }
      throw ErrorHandler.handleError(error);
    }
  }
}
