import 'package:flutter/material.dart';
import 'package:motivational/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:motivational/app/my_app_view.dart';

import '../model/notification_sub_theme.dart';
import '../repositories/theme_repository.dart';
import '../utils/custom_snackbar.dart';

class FavoriteProvider with ChangeNotifier {
  final _themeRepo = ThemeRepository();
  List<NotificationSubTheme> notificationSubThemeFavoriteList = [];
  bool getFavoriteSubThemesLoading = false;
  startGetFavoriteSubThemesLoading() {
    getFavoriteSubThemesLoading = true;
    notifyListeners();
  }

  stopGetFavoriteSubThemesLoading() {
    getFavoriteSubThemesLoading = false;
    notifyListeners();
  }

  Future<void> getFavoriteSubThemeNotifications() async {
    startGetFavoriteSubThemesLoading();
    try {
      notificationSubThemeFavoriteList =
          await _themeRepo.getFavoriteSubThemeNotifications();
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetFavoriteSubThemesLoading();
    }
  }

  //mark as favorite or un favorite
  bool markAsFavoriteLoading = false;
  startMarkAsFavoriteLoading() {
    markAsFavoriteLoading = true;
    notifyListeners();
  }

  stopMarkAsFavoriteLoading() {
    markAsFavoriteLoading = false;
    notifyListeners();
  }

  Future<void> markAsFavoriteOrUnFavoriteSubTheme(int subThemeId) async {
    startMarkAsFavoriteLoading();

    final body = {"theme_id": subThemeId};
    try {
      MyApp.gCtx.read<ThemeProvider>().changeFavStatusOfSubThemeDetail();
      final response =
          await _themeRepo.markAsFavoriteOrUnFavoriteSubTheme(body);

      if (response != null) {
        notificationSubThemeFavoriteList
            .removeWhere((val) => val.subtheme.id == subThemeId);
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
      MyApp.gCtx.read<ThemeProvider>().changeFavStatusOfSubThemeDetail();
    } finally {
      stopMarkAsFavoriteLoading();
    }
  }
}
