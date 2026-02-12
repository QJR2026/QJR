import '../constants/api_end_points.dart';
import '../model/notification_sub_theme.dart';
import '../model/quote_theme.dart';
import '../model/sub_theme.dart';
import '../services/api_service.dart';
import '../utils/error_handler.dart';

class ThemeRepository {
  Future<List<QuoteTheme>> getAllQuoteThemes() async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.get(ApiEndpoints.getAllQuoteThemes);

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

  Future<List<NotificationSubTheme>> getAllSubThemeNotifications() async {
    final ApiService apiService = ApiService();
    try {
      final response =
          await apiService.get(ApiEndpoints.getAllSubThemeNotifications);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSubTheme.fromJsonList(
            response.data["data"] as List<dynamic>);
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

  Future<SubTheme?> getSubThemeNotificationDetail({required String id}) async {
    final ApiService apiService = ApiService();
    try {
      final response =
          await apiService.get(ApiEndpoints.getSubThemeNotificationDetail(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data["data"] != null) {
          return SubTheme.fromJson(
            response.data["data"] as Map<String, dynamic>,
          );
        }
      } else {
        throw CustomException(
          message: response.data["message"] ?? 'Unexpected error occurred',
          code: response.statusCode,
        );
      }
    } catch (error) {
      throw ErrorHandler.handleError(error);
    }
    return null;
  }

  Future<List<NotificationSubTheme>> getFavoriteSubThemeNotifications() async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService.get(ApiEndpoints.getFavoriteSubThemes);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSubTheme.fromJsonList(
            response.data["data"] as List<dynamic>);
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

  Future<dynamic> saveSelectedTheme(Map<String, dynamic> body) async {
    final ApiService apiService = ApiService();
    try {
      final response =
          await apiService.post(ApiEndpoints.saveTheme, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //  ApiService.userData =
        //       ApiService.userData?.copyWith(theme: true);
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

  Future<dynamic> markAsFavoriteOrUnFavoriteSubTheme(
      Map<String, dynamic> body) async {
    final ApiService apiService = ApiService();
    try {
      final response = await apiService
          .post(ApiEndpoints.markAsFavoritesOrUnFavoriteSubThemes, data: body);

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
}
