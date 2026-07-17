import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/api_end_points.dart';
import '../model/presigned_upload.dart';
import '../services/api_service.dart';
import '../utils/error_handler.dart';

class UploadRepository {
  final ApiService _apiService = ApiService();

  // A bare Dio instance: S3 presigned uploads must not carry our API's
  // base URL, auth headers or interceptors.
  final Dio _s3Dio = Dio();

  static const Map<String, String> _contentTypesByExtension = {
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
  };

  Future<PresignedUpload> _getPresignedUrl({
    required String fileName,
    required String contentType,
    required String folder,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.presignUpload,
        data: {
          'fileName': fileName,
          'contentType': contentType,
          'folder': folder,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PresignedUpload.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }

      throw CustomException(
        message: response.data['message'] ?? 'Unexpected error occurred',
        code: response.statusCode,
      );
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
  }

  /// Uploads [file] to S3 via a presigned URL and returns its public URL.
  Future<String> uploadImage({
    required File file,
    required String folder,
  }) async {
    final fileName = file.path.split('/').last;
    final contentType = _contentTypesByExtension[
            fileName.split('.').last.toLowerCase()] ??
        'application/octet-stream';

    final presigned = await _getPresignedUrl(
      fileName: fileName,
      contentType: contentType,
      folder: folder,
    );

    try {
      await _s3Dio.put(
        presigned.uploadUrl,
        data: await file.readAsBytes(),
        options: Options(headers: {Headers.contentTypeHeader: contentType}),
      );
    } on DioException {
      // S3 returns XML error bodies, which ErrorHandler isn't equipped to
      // parse, so surface a plain message instead.
      throw CustomException(
        message: 'Failed to upload image. Please try again.',
      );
    }

    return presigned.imageUrl;
  }
}
