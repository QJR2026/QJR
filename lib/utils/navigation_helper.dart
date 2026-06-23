import 'dart:convert';

import '../app/my_app_view.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';
import '../utils/routes.dart';

class NavigationHelper {
  static final _prefs = SharedPreferencesService();

  /// Single source of truth for post-auth routing.
  /// Checks theme and preference completion, saves prefs on reaching home.
  static void navigateAfterAuth() {
    final userData = ApiService.userData;
    if (userData == null) {
      MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (r) => false);
      return;
    }
    if (!userData.isThemeSelected) {
      MyApp.gState.pushNamedAndRemoveUntil(
          Routes.selectQuoteGroupsTheme, (r) => false);
      return;
    }
    if (!userData.hasPreference) {
      MyApp.gState.pushNamedAndRemoveUntil(
        Routes.selectNotificationTimePref,
        (r) => false,
        arguments: userData.quotetheme,
      );
      return;
    }
    _prefs.setString("token", ApiService.authToken ?? '');
    _prefs.setString("data", jsonEncode(userData.toJson()));
    MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (r) => false);
  }
}
