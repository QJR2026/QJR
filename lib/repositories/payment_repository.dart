import 'package:motivational/model/payment_plan.dart';

import '../constants/api_end_points.dart';
import '../services/api_service.dart';
import '../utils/error_handler.dart';

class PaymentRepository {
  final ApiService _apiService = ApiService();
  // final SharedPreferencesService _sharedPreferences =
  //     SharedPreferencesService();
  Future<List<PaymentPlan>> getAllPackages() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getAllPackages);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentPlan.fromJsonList(response.data["data"] as List<dynamic>);
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

  Future<dynamic> savePaymentMethodDetail(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.createPaymentMethod, data: body);

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

  Future<dynamic> updatePaymentPlan(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.patch(ApiEndpoints.editPaymentPlan, data: body);

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

  Future<dynamic> updateAutoRenewStatus(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.patch(ApiEndpoints.autoRenewUpdate, data: body);

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

  Future<dynamic> updatePaymentPlanNew(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.updatePaymentPlan, data: body);

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

  Future<dynamic> checkSubscription(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.checkSubscription, data: body);

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
}
