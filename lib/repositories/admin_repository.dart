import 'dart:developer';

import 'package:motivational/constants/api_end_points.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/model/sub_theme.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/utils/error_handler.dart';

class AdminRepository {
  final ApiService apiService = ApiService();

  Future<QuoteTheme> createTheme(String themeName, String description) async {
    try {
      final response = await apiService.post(AdminApiUrls.addTheme,
          data: {"themeName": themeName, "themeDescription": description});
      log("[CREATE RESPONSE] $response");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return QuoteTheme.fromJson(
            (response.data['data']['theme'] as List).first);
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

  Future<QuoteTheme> updateTheme(
      {required int id,
      required String themeName,
      required String description}) async {
    try {
      final response =
          await apiService.patch(AdminApiUrls.updateTheme(id), data: {
        "themeName": themeName,
        "themeDescription": description,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return QuoteTheme.fromJson(
            (response.data['data']['theme'] as List).first);
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

  Future<bool> deleteTheme(int id) async {
    try {
      final response = await apiService.delete(AdminApiUrls.deleteTheme(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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

  Future<List<QuoteTheme>> getAllThemes() async {
    try {
      final response = await apiService.get(AdminApiUrls.getAllThemes);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return QuoteTheme.fromJsonList(response.data["data"] as List<dynamic>);
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

  /////////QUOTES API CALLS
  ///
  Future<SubTheme> createquote({
    required String quote,
    required dynamic id,
  }) async {
    try {
      final response = await apiService.post(AdminApiUrls.addSubTheme,
          data: {"description": quote, "theme_id": id});
      log("[CREATE RESPONSE] $response");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SubTheme.fromJson(
            (response.data['data']['theme'] as List).first);
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

  Future<List<SubTheme>> getQuotesById({required dynamic id}) async {
    try {
      final response = await apiService.get(AdminApiUrls.getAllSubThemes(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SubTheme.fromJsonList(
            response.data["data"]['subthemes'] as List<dynamic>);
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

  Future<bool> deleteQuote(int id) async {
    try {
      final response = await apiService.delete(AdminApiUrls.deleteSubTheme(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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

  Future<SubTheme> updateSubTheme(
      {required int id,
      required String themeName,
      required int subThemeId}) async {
    try {
      final response = await apiService
          .patch(AdminApiUrls.updateSubTheme(subThemeId), data: {
        // "theme_id": subThemeId,
        "description": themeName,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SubTheme.fromJson(
            (response.data['data']['theme'] as List).first);
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
  // deleteQuote() {}
  // updateQuote() {}
}
