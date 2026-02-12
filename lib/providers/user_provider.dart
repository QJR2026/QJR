import 'package:flutter/material.dart';
import 'package:motivational/model/user_data.dart';

import '../repositories/auth_respository.dart';
import '../utils/custom_snackbar.dart';

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

  Future<void> getUserDetail() async {
    startLoading();
    try {
      userData = await _authRepo.getUser();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }
}
