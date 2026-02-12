import 'package:flutter/material.dart';

import 'package:motivational/app/my_app_view.dart';

import '../model/notification_sub_theme.dart';
import '../model/quote_theme.dart';
import '../model/sub_theme.dart';
import '../repositories/theme_repository.dart';
import '../services/api_service.dart';
import '../utils/custom_snackbar.dart';
import '../utils/routes.dart';

class ThemeProvider with ChangeNotifier {
  static var motivationalTheme = QuoteTheme(
    id: 1,
    name: 'Motivational',
    description: 'Daily motivational quotes to inspire and uplift',
  );

  static final _themeRepo = ThemeRepository();
  bool getQuoteThemesLoading = false;

  final List<NotificationSubTheme> notificationStaticSubThemes = [
    NotificationSubTheme(
      id: 1,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 101,
        description:
            '“Believe in the power of your dreams—they’re the blueprint of your future.”',
        isLiked: false,
      ),
      createdAt: '2025-08-01',
    ),
    NotificationSubTheme(
      id: 2,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 102,
        description:
            '“Every sunrise brings a chance to rewrite your story. Make today count.”',
        isLiked: false,
      ),
      createdAt: '2025-08-02',
    ),
    NotificationSubTheme(
      id: 3,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 103,
        description:
            '“The only limit to your success is the strength of your desire to grow.”',
        isLiked: false,
      ),
      createdAt: '2025-08-03',
    ),
    NotificationSubTheme(
      id: 4,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 104,
        description:
            '“Push past fear—it’s only standing between you and greatness.”',
        isLiked: false,
      ),
      createdAt: '2025-08-04',
    ),
    NotificationSubTheme(
      id: 5,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 105,
        description:
            '“You’re not behind. You’re just building something worth the wait.”',
        isLiked: false,
      ),
      createdAt: '2025-08-05',
    ),
    NotificationSubTheme(
      id: 6,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 106,
        description:
            '“One small positive action today can change your whole tomorrow.”',
        isLiked: false,
      ),
      createdAt: '2025-08-06',
    ),
    NotificationSubTheme(
      id: 7,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 107,
        description:
            '“Failure is not defeat. It’s just proof that you’re trying.”',
        isLiked: false,
      ),
      createdAt: '2025-08-07',
    ),
    NotificationSubTheme(
      id: 8,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 108,
        description:
            '“Consistency beats intensity. Show up even when it’s hard.”',
        isLiked: false,
      ),
      createdAt: '2025-08-08',
    ),
    NotificationSubTheme(
      id: 9,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 109,
        description:
            '“Don’t compare your beginning to someone else’s middle. Walk your path.”',
        isLiked: false,
      ),
      createdAt: '2025-08-09',
    ),
    NotificationSubTheme(
      id: 10,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 110,
        description: '“Rest if you must—but never quit.”',
        isLiked: false,
      ),
      createdAt: '2025-08-10',
    ),
    NotificationSubTheme(
      id: 11,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 111,
        description:
            '“Each day is a blank page. Fill it with purpose, not doubt.”',
        isLiked: false,
      ),
      createdAt: '2025-08-11',
    ),
    NotificationSubTheme(
      id: 12,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 112,
        description:
            '“You already have what it takes. Just believe and begin.”',
        isLiked: false,
      ),
      createdAt: '2025-08-12',
    ),
    NotificationSubTheme(
      id: 13,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 113,
        description:
            '“Greatness doesn’t arrive—it’s built step by step, choice by choice.”',
        isLiked: false,
      ),
      createdAt: '2025-08-13',
    ),
    NotificationSubTheme(
      id: 14,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 114,
        description:
            '“The effort you make today becomes the confidence you carry tomorrow.”',
        isLiked: false,
      ),
      createdAt: '2025-08-14',
    ),
    NotificationSubTheme(
      id: 15,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 115,
        description:
            '“Be stronger than your excuses. Your future depends on it.”',
        isLiked: false,
      ),
      createdAt: '2025-08-15',
    ),
    NotificationSubTheme(
      id: 16,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 116,
        description:
            '“Even the slowest progress is still progress. Keep going.”',
        isLiked: false,
      ),
      createdAt: '2025-08-16',
    ),
    NotificationSubTheme(
      id: 17,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 117,
        description: '“Don’t wait for the right time. Create it.”',
        isLiked: false,
      ),
      createdAt: '2025-08-17',
    ),
    NotificationSubTheme(
      id: 18,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 118,
        description:
            '“The harder you work for something, the greater the reward will feel.”',
        isLiked: false,
      ),
      createdAt: '2025-08-18',
    ),
    NotificationSubTheme(
      id: 19,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 119,
        description: '“You were made for more—don’t settle for less.”',
        isLiked: false,
      ),
      createdAt: '2025-08-19',
    ),
    NotificationSubTheme(
      id: 20,
      theme: motivationalTheme,
      subtheme: SubTheme(
        id: 120,
        description: '“Turn your setbacks into setups for comebacks.”',
        isLiked: false,
      ),
      createdAt: '2025-08-20',
    ),
  ];

  startGetQuoteThemesLoading() {
    getQuoteThemesLoading = true;
    notifyListeners();
  }

  stopGetQuoteThemesLoading() {
    getQuoteThemesLoading = false;
    notifyListeners();
  }

  bool getSubThemesLoading = false;
  startGetSubThemesLoading() {
    getSubThemesLoading = true;
    notifyListeners();
  }

  stopGetSubThemesLoading() {
    getSubThemesLoading = false;
    notifyListeners();
  }

  bool saveQuoteThemeLoading = false;

  startSaveQuoteThemeLoading() {
    saveQuoteThemeLoading = true;
    notifyListeners();
  }

  stopSaveQuoteThemeLoading() {
    saveQuoteThemeLoading = false;
    notifyListeners();
  }

  List<QuoteTheme> quoteThemesList = [];

  List<NotificationSubTheme> notificationSubThemeList = [];

  Future<void> getAllQuoteThemes() async {
    startGetQuoteThemesLoading();
    try {
      quoteThemesList = await _themeRepo.getAllQuoteThemes();
    } catch (error) {
      stopGetQuoteThemesLoading();
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetQuoteThemesLoading();
    }
  }

  bool isLoggedIn({bool showErrorToast = true}) {
    final isLoggedInValue = ApiService.authToken != null;
    if (!isLoggedInValue && showErrorToast) {
      CustomSnackBar.showSignInError();
    }
    return isLoggedInValue;
  }

  Future<void> getAllSubThemeNotifications() async {
    startGetSubThemesLoading();
    try {
      if (isLoggedIn(showErrorToast: false)) {
        notificationSubThemeList =
            await _themeRepo.getAllSubThemeNotifications();
      } else {
        await Future.delayed(const Duration(seconds: 2));
        notificationSubThemeList = notificationStaticSubThemes;
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetSubThemesLoading();
    }
  }

  //detail notification sub theme

  bool getSubThemeDetailLoading = false;
  startGetSubThemeDetailLoading() {
    getSubThemeDetailLoading = true;
    notifyListeners();
  }

  stopGetSubThemeDetailLoading() {
    getSubThemeDetailLoading = false;
    notifyListeners();
  }

  SubTheme? notificationSubThemeDetail;
  setNotificationSubThemeDetail(SubTheme subTheme) {
    notificationSubThemeDetail = subTheme;
    notifyListeners();
  }

  Future<void> getSubThemeNotificationDetail({required String id}) async {
    startGetSubThemeDetailLoading();
    try {
      notificationSubThemeDetail =
          await _themeRepo.getSubThemeNotificationDetail(id: id);
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetSubThemeDetailLoading();
    }
  }

  void changeFavStatusOfSubThemeDetail() {
    if (notificationSubThemeDetail == null) return;

    notificationSubThemeDetail = notificationSubThemeDetail?.copyWith(
      isLiked: !(notificationSubThemeDetail?.isLiked ?? false),
    );

    if (notificationSubThemeDetail != null) {
      for (int i = 0; i < notificationSubThemeList.length; i++) {
        if (notificationSubThemeList[i].subtheme.id ==
            notificationSubThemeDetail?.id) {
          notificationSubThemeList[i] = notificationSubThemeList[i]
              .copyWith(subtheme: notificationSubThemeDetail);
          break;
        }
      }
    }

    notifyListeners();
  }

  Future<void> saveSelectedTheme(QuoteTheme theme) async {
    startSaveQuoteThemeLoading();
    try {
      final body = {"themeId": theme.id};
      final response = await _themeRepo.saveSelectedTheme(body);
      if (response != null) {
        ApiService.userData = ApiService.userData?.copyWith(theme: theme);
        if (ApiService.userData?.hasPreference == true) {
          MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (val) => false);
        } else {
          MyApp.gState.pushNamedAndRemoveUntil(
            Routes.selectNotificationTimePref,
            (val) => false,
            arguments: theme,
          );
        }
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopSaveQuoteThemeLoading();
    }
  }
}
