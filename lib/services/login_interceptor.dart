import 'dart:convert';
import 'dart:developer'; // For better log visibility
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/repositories/auth_repository.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/device_info.dart'; // Assuming you have this utility
import 'package:motivational/utils/platform_features.dart';
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

    // Backend treats Android devices as complimentary premium when this header
    // is present. Sent on Android only: iOS requests stay unchanged (the
    // backend defaults a missing platform to iOS).
    if (PlatformFeatures.isAndroid) {
      options.headers['x-platform'] = 'android';
    }

    log("🌍 REQUEST [${options.method}] → ${options.uri}");
    log("🔸 Headers: ${jsonEncode(options.headers)}");
    log("🟢 Query Parameters: ${jsonEncode(options.queryParameters)}");
    if (options.data != null && kDebugMode) {
      log("📌 Body: ${_safeEncode(options.data)}");
    }

    handler.next(options);
  }

  // FormData (multipart uploads) can't be passed to jsonEncode; fall back
  // to toString() for anything that isn't plain JSON-encodable data.
  String _safeEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("✅ RESPONSE [${response.statusCode}] → ${response.requestOptions.uri}");
    log("📝 Data: ${jsonEncode(response.data)}");

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("❌ ERROR [${err.response?.statusCode}] → ${err.requestOptions.uri}");
    log("⚠️ Message: ${err.message}");
    if (err.response?.data != null) {
      log("🛑 Error Data: ${jsonEncode(err.response?.data)}");
    }

    // Handle 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      ApiService.authToken = null;
      ApiService.userData = null;
      AuthRepository().clearPreferences();
      MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (route) => false);
    }

    handler.next(err);
  }
}
