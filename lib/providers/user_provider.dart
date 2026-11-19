import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motivational/model/user_data.dart';

import '../repositories/auth_repository.dart';
import '../services/api_service.dart';
import '../services/shared_preference_service.dart';
import '../utils/custom_snackbar.dart';
import '../utils/error_handler.dart';
import '../utils/platform_features.dart';

class UserProvider with ChangeNotifier {
  final _authRepo = AuthRepository();

  bool loading = false;

  startLoading() {
    loading = true;
    notifyListeners();
  }

  stopLoading() {
    loading = false;
    notifyListeners();
  }

  UserData? userData;

  final _sharedPreferences = SharedPreferencesService();

  Future<void> getUserDetail() async {
    startLoading();
    try {
      userData = await _authRepo.getUser();
      ApiService.userData = userData;
      _sharedPreferences.setString("data", jsonEncode(userData!.toJson()));
    } on NetworkException {
      rethrow; // splash catches this to show no-internet overlay
    } catch (error) {
      // Android: a 401 here means the saved session is no longer valid (e.g.
      // it was created by an older build with a different device ID). The
      // Dio interceptor already sends the user to login, so skip the error
      // toast. iOS behaviour is unchanged.
      final isExpiredSession = error is CustomException && error.code == 401;
      if (!(isExpiredSession && PlatformFeatures.isAndroid)) {
        CustomSnackBar.showError(message: error.toString());
      }
    } finally {
      stopLoading();
    }
  }
}
