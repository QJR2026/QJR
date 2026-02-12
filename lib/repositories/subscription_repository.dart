import '../constants/api_end_points.dart';
import '../services/api_service.dart';
import '../utils/error_handler.dart';

class SubscriptionRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> validateReciept(Map<String, dynamic> body) async {
    try {
      final response =
          await _apiService.post(ApiEndpoints.validateReciept, data: body);

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
