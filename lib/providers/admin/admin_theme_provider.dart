import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/repositories/admin_repository.dart';
import 'package:motivational/utils/custom_snackbar.dart';

class AdminThemeProvider with ChangeNotifier {
  List<QuoteTheme> themeList = [];
  var themeLoader = false;
  var deleteThemeLoader = false;
  var addThemeLoader = false;
  var updateThemeLoader = false;
  final AdminRepository _adminRepository = AdminRepository();

  deleteTheme(int id) async {
    deleteThemeLoader = true;
    notifyListeners();
    try {
      final response = await _adminRepository.deleteTheme(id);
      if (response) themeList.removeWhere((e) => (e.id ?? 0) == id);
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Theme deleted successfully");
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      deleteThemeLoader = false;
      notifyListeners();
    }
  }

  updateTheme(
      {required String name,
      required String description,
      required int id,
      required int index}) async {
    updateThemeLoader = true;
    notifyListeners();
    try {
      var response = await _adminRepository.updateTheme(
          id: id, themeName: name, description: description);
      themeList.removeAt(index);
      themeList.insert(index, response);
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Theme updated successfully");
    } catch (e) {
      MyApp.gState.pop();

      CustomSnackBar.showError(message: e.toString());
    } finally {
      MyApp.gState.pop();

      updateThemeLoader = false;
      notifyListeners();
    }
  }

  addTheme({required String themeName, required String description}) async {
    addThemeLoader = true;
    notifyListeners();
    try {
      var response = await _adminRepository.createTheme(themeName, description);
      themeList.insert(0, response);
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Theme added successfully");
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      MyApp.gState.pop();
      addThemeLoader = false;
      notifyListeners();
    }
  }

  getThemes() async {
    themeLoader = true;
    notifyListeners();
    try {
      var response = await _adminRepository.getAllThemes();
      themeList = response;
      notifyListeners();
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      themeLoader = false;
      notifyListeners();
    }
  }
}
