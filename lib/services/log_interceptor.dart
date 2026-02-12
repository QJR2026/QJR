import 'dart:convert';
import 'package:dio/dio.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🌍 REQUEST [${options.method}] → ${options.uri}");
    print("🔸 Headers: ${options.headers}");
    print("📌 Data: ${jsonEncode(options.data)}"); // Convert data to JSON format
    print("🟢 Query Parameters: ${options.queryParameters}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ RESPONSE [${response.statusCode}] → ${response.requestOptions.uri}");
    print("📝 Data: ${jsonEncode(response.data)}");

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ ERROR [${err.response?.statusCode}] → ${err.requestOptions.uri}");
    print("⚠️ Message: ${err.message}");
    print("🛑 Error Data: ${jsonEncode(err.response?.data)}");

    super.onError(err, handler);
  }
}
