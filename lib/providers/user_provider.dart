import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:motivational/model/user_data.dart';

import '../repositories/auth_respository.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';
import '../utils/custom_snackbar.dart';
import '../utils/error_handler.dart';

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
      log("data fetched");
    } on NetworkException {
      rethrow; // splash catches this to show no-internet overlay
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }
}
