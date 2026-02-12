
import 'package:dio/dio.dart';

class ErrorHandler {
  static CustomException handleError(Object error) {
    if (error is DioException) {
      // Handle Dio exceptions
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return CustomException(
              message: 'Connection timeout. Please try again.');
        case DioExceptionType.sendTimeout:
          return CustomException(message: 'Request timeout. Please try again.');
        case DioExceptionType.receiveTimeout:
          return CustomException(
              message: 'Response timeout. Please try again.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final errorMessage = error.response?.data["message"] ??
              error.response?.data["messaage"] ??
              'Server error occurred';
          return CustomException(message: errorMessage, code: statusCode);
        case DioExceptionType.cancel:
          return CustomException(message: 'Request was cancelled.');
        case DioExceptionType.unknown:
          return CustomException(message: '${error.message}');
        default:
          return CustomException(message: 'Something went wrong.');
      }
    } else {
      // Handle non-Dio exceptions
      return CustomException(message: error.toString());
    }
  }
}

class CustomException implements Exception {
  final String message;
  final int? code;

  CustomException({required this.message, this.code});

  @override
  String toString() {
    return message;
  }
}