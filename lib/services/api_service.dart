import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:motivational/services/login_interceptor.dart';


import '../constants/api_end_points.dart';
import '../model/user_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static String? authToken;
  static UserData? userData;

  final Dio _dio;

  ApiService._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': 'quick_jesus_reminder',
            },
          ),
        ) {
    _dio.interceptors.addAll([
     
      DioInterceptor( ),
      LogInterceptor(),
    ]);
  }

  factory ApiService() {
    return _instance;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(
    String endpoint,
  ) async {
    try {
      final response = await _dio.delete(
        endpoint,
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        log("Connection Timeout Exception");
        break;

      case DioExceptionType.sendTimeout:
        log("Send Timeout Exception");
        break;

      case DioExceptionType.receiveTimeout:
        log("Receive Timeout Exception");
        break;

      case DioExceptionType.badResponse:
        log("Received invalid status code: ${error.response?.data}");
        break;

      case DioExceptionType.cancel:
        log("Request to API server was cancelled");
        break;

      case DioExceptionType.unknown:
        log("Unexpected error: ${error.message}");
        break;

      case DioExceptionType.badCertificate:
        log("DioExceptionType.badCertificate: ${error.message}");
        break;

      default:
        log("Unhandled DioExceptionType: ${error.type}");
        break;
    }
  }
}
