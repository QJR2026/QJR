import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/sub_theme.dart';
import 'package:motivational/repositories/admin_repository.dart';
import 'package:motivational/utils/custom_snackbar.dart';

class AdminQuoteProvider with ChangeNotifier {
  List<SubTheme> quotesList = [];
  var initLoader = false;
  var deleteThemeLoader = false;
  var createQuoteLoader = false;
  var updateThemeLoader = false;
  final AdminRepository _adminRepository = AdminRepository();
  int? _themeId;
  int get themeId => _themeId ?? 0;

  deleteTheme(int id) async {
    deleteThemeLoader = true;
    notifyListeners();
    try {
      final response = await _adminRepository.deleteQuote(id);
      if (response) quotesList.removeWhere((e) => (e.id ?? 0) == id);
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Theme deleted successfully");
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      deleteThemeLoader = false;
      notifyListeners();
    }
  }

  updateTheme({
    required String name,
    index,
    subThemeId,
  }) async {
    updateThemeLoader = true;
    notifyListeners();
    try {
      var response = await _adminRepository.updateSubTheme(
          subThemeId: subThemeId, id: themeId, themeName: name);
      quotesList.removeAt(index);
      quotesList.insert(index, response);
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Quote updated successfully");
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      MyApp.gState.pop();

      updateThemeLoader = false;
      notifyListeners();
    }
  }

  createQuote({
    required String quote,
  }) async {
    createQuoteLoader = true;
    notifyListeners();
    try {
      var response =
          await _adminRepository.createquote(quote: quote, id: themeId);
      quotesList.insert(0, response);
      MyApp.gState.pop();
      notifyListeners();
      CustomSnackBar.showSuccess(message: "Quote created successfully");
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      createQuoteLoader = false;
      notifyListeners();
    }
  }

  getAllQuotes() async {
    initLoader = true;
    quotesList.clear();
    notifyListeners();
    try {
      var response = await _adminRepository.getQuotesById(id: themeId);
      quotesList.addAll(response);
      notifyListeners();
    } catch (e) {
      CustomSnackBar.showError(message: e.toString());
    } finally {
      initLoader = false;
      notifyListeners();
    }
  }

  setThemeID(int id) {
    _themeId = id;
    notifyListeners();
  }
}
