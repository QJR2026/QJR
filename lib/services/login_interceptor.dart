import 'dart:convert';
import 'dart:developer'; // For better log visibility
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/repositories/auth_respository.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/device_info.dart'; // Assuming you have this utility
import 'package:motivational/utils/routes.dart'; // Your route management

class DioInterceptor extends Interceptor {
  DioInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (ApiService.authToken != null) {
      final String deviceId = await DeviceInfo.getDeviceId() ?? '';
      options.headers['accesstoken'] = 'Bearer ${ApiService.authToken}';
      options.headers['deviceid'] = deviceId;
    }

    log("🌍 REQUEST [${options.method}] → ${options.uri}");
    log("🔸 Headers: ${jsonEncode(options.headers)}");
    log("🟢 Query Parameters: ${jsonEncode(options.queryParameters)}");
    if (options.data != null) {
      if (kDebugMode) {
        log("📌 Body: ${jsonEncode(options.data)}");
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("✅ RESPONSE [${response.statusCode}] → ${response.requestOptions.uri}");
    log("📝 Data: ${jsonEncode(response.data)}");

    handler.next(response);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    log("❌ ERROR [${e.response?.statusCode}] → ${e.requestOptions.uri}");
    log("⚠️ Message: ${e.message}");
    if (e.response?.data != null) {
      log("🛑 Error Data: ${jsonEncode(e.response?.data)}");
    }

    // Handle 401 (Unauthorized)
    if (e.response?.statusCode == 401) {
      AuthRepository().clearPreferences();
      MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (route) => false);
    }
    // if (e.response?.statusCode == 507) {
    //   //renue
    //   MyApp.gState.pushNamed(
    //     Routes.editPaymentMehtod,
    //   );
    // }
    // if (e.response?.statusCode == 400 &&
    //     e.response?.data["message"] == "User package not found") {
    //   MyApp.gState.pushNamedAndRemoveUntil(
    //     Routes.paymentMethod,
    //     (route) => false,
    //   );
    // }

    handler.next(e);
  }
}
