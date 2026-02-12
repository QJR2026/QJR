import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motivational/extensions/date_time_extensions.dart';
import 'package:motivational/model/preference.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/providers/theme_provider.dart';
import 'package:motivational/services/api_service.dart';
import 'package:motivational/services/shared_prefrence_service.dart';
import 'package:provider/provider.dart';

import 'package:motivational/app/my_app_view.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../repositories/notification_time_preference_repository.dart';
import '../utils/custom_snackbar.dart';
import '../utils/routes.dart';
import '../utils/time_zone.dart';

class NotificationTimePreferenceProvider with ChangeNotifier {
  final _notificationRepo = NotificationTimePreferenceRepository();
  final List<String> daysConst = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  List<String> selectedDays = [];
  TimeOfDay? selectedTime;
  TimeOfDay? selectedEndTime;
  TimeOfDay? selectedDailyTime;
  TimeOfDay? selectedDailyEndTime;

  init() {
    selectedTime = null;
    selectedDailyTime = null;
    selectedEndTime = null;
    selectedDailyEndTime = null;
    selectedDays = [];
    selectedThemeId = null;
    notifyListeners();
  }

  setCustomTime(TimeRange time) {
    if (time.startTime == time.endTime) {
      CustomSnackBar.showError(
          message: "Start time and end time cannot be the same");

      return;
    }
    selectedTime = time.startTime;
    selectedEndTime = time.endTime;
    selectedDailyTime = null;
    selectedDailyEndTime = null;
    notifyListeners();
  }

  setDailyTime(TimeRange time) {
    if (time.startTime == time.endTime) {
      CustomSnackBar.showError(
          message: "Start time and end time cannot be the same");

      return;
    }
    selectedDailyTime = time.startTime;
    selectedDailyEndTime = time.endTime;
    selectedTime = null;
    selectedEndTime = null;
    selectedDays.clear();
    notifyListeners();
  }

  void onDaySelect(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    notifyListeners();
  }

  // String get formatDays {
  //   return (selectedDays.length < 2 ? selectedDays : selectedDays.sublist(0, 2))
  //       .map((ele) => ele.substring(0, 2))
  //       .join(",")
  //       .toString();
  // }
  String get formatDays {
    // Ensure selectedDays is ordered as per daysConst
    List<String> orderedDays = selectedDays
        .where((day) => daysConst.contains(day))
        .toList()
      ..sort((a, b) => daysConst.indexOf(a).compareTo(daysConst.indexOf(b)));

    return (orderedDays.length < 2 ? orderedDays : orderedDays.sublist(0, 2))
        .map((ele) => ele.substring(0, 2))
        .join(",")
        .toString();
  }

  bool loading = false;

  startLoading() {
    loading = true;
    notifyListeners();
  }

  stopLoading() {
    loading = false;
    notifyListeners();
  }

  Future<void> saveDaysAndTimePrefrenceForNotication(int themeId,
      {bool fromUpdate = false}) async {
    if (selectedTime == null && selectedDailyTime == null) {
      CustomSnackBar.showError(
          message: "Please select time and days before saving.");
      return;
    }

// Check if days are selected for custom time
    if (selectedTime != null) {
      // Remove empty strings from the list
      selectedDays =
          selectedDays.where((day) => day.trim().isNotEmpty).toList();

      if (selectedDays.isEmpty) {
        CustomSnackBar.showError(
            message: "Please select at least one valid day before saving.");
        return;
      }
    }
    startLoading();
    try {
      String? startTime;
      String? endTime;
      List<String>? daysToSend;
      if (selectedTime != null) {
        startTime = selectedTime?.to24HourFormat();
        endTime = selectedEndTime?.to24HourFormat();
        daysToSend = selectedDays;
      } else if (selectedDailyTime != null) {
        startTime = selectedDailyTime?.to24HourFormat();
        endTime = selectedDailyEndTime?.to24HourFormat();
        daysToSend = ["Daily"];
      }
      final body = {
        "notificationStartTime": startTime ?? '',
        "notificationEndTime": endTime ?? '',
        "days": daysToSend,
        "timezone": await TimeZone.timeZone(),
        "themeId": themeId,
      };
      await _notificationRepo.saveDaysAndTimePrefrenceForNotication(body);
      if (fromUpdate) {
        MyApp.gState.pop();
      } else {
        MyApp.gState.pushNamedAndRemoveUntil(Routes.home, (val) => false);
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Future<void> saveThemeAndTimePrefrence(QuoteTheme theme) async {
    if (selectedTime == null && selectedDailyTime == null) {
      CustomSnackBar.showError(
          message: "Please select time and days before saving.");
      return;
    }

// Check if days are selected for custom time
    if (selectedTime != null) {
      // Remove empty strings from the list
      selectedDays =
          selectedDays.where((day) => day.trim().isNotEmpty).toList();

      if (selectedDays.isEmpty) {
        CustomSnackBar.showError(
            message: "Please select at least one valid day before saving.");
        return;
      }
    }

    startLoading();
    try {
      String? startTime;
      String? endTime;
      List<String>? daysToSend;

      if (selectedTime != null) {
        startTime = selectedTime?.to24HourFormat();
        endTime = selectedEndTime?.to24HourFormat();
        daysToSend = selectedDays;
      } else if (selectedDailyTime != null) {
        startTime = selectedDailyTime?.to24HourFormat();
        endTime = selectedDailyEndTime?.to24HourFormat();
        daysToSend = ["Daily"];
      }
      final body = {
        "notificationStartTime": startTime ?? '',
        "notificationEndTime": endTime ?? '',
        "days": daysToSend,
        "timezone": await TimeZone.timeZone(),
        "themeId": theme.id,
      };

      final response = await _notificationRepo.saveThemeAndTimePrefrence(body);
      if (response != null) {
        ApiService.userData = ApiService.userData?.copyWith(theme: theme);
        SharedPreferencesService()
            .setString("data", jsonEncode(ApiService.userData));
        MyApp.gState.pop();
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopLoading();
    }
  }

  Preference? preference;

  bool getPreferenceLoading = false;

  startGetPreferenceLoading() {
    getPreferenceLoading = true;
    notifyListeners();
  }

  stopGetPreferenceLoading() {
    getPreferenceLoading = false;
    notifyListeners();
  }

//get preference
  // Future<void> getPrefrenceForNotication() async {
  //   startGetPreferenceLoading();
  //   try {
  //     init();

  //     preference = await _notificationRepo.getPrefrenceForNotication();
  //     if (preference != null) {
  //       selectedDays = preference!.days ?? [];
  //       if (preference!.isDaily) {
  //         selectedDailyTime = preference!.notificationStartTime;
  //         selectedDailyEndTime = preference!.notificationEndTime;
  //         selectedTime = null;
  //         selectedEndTime = null;
  //       } else {
  //         selectedTime = preference!.notificationStartTime;
  //         selectedEndTime = preference!.notificationEndTime;
  //         selectedDailyTime = null;
  //         selectedDailyEndTime = null;
  //       }
  //     }
  //     final themeProvider = MyApp.gCtx.read<ThemeProvider>();
  //     await themeProvider.getAllQuoteThemes();
  //     if (themeProvider.quoteThemesList.isNotEmpty) {
  //       selectedThemeId = ApiService.userData?.quotetheme?.id;
  //     }
  //   } catch (error) {
  //     CustomSnackBar.showError(message: error.toString());
  //   } finally {
  //     stopGetPreferenceLoading();
  //   }
  // }

  Future<void> getPrefrenceForNotication() async {
    selectedThemeId = null;
    startGetPreferenceLoading();
    try {
      init();
      final themeProvider = MyApp.gCtx.read<ThemeProvider>();
      await themeProvider.getAllQuoteThemes();

      final fetchedPreference =
          await _notificationRepo.getPrefrenceForNotication();
      preference = fetchedPreference;

      if (fetchedPreference != null) {
        selectedDays = fetchedPreference.days ?? [];
        if (fetchedPreference.isDaily) {
          selectedDailyTime = fetchedPreference.notificationStartTime;
          selectedDailyEndTime = fetchedPreference.notificationEndTime;
          selectedTime = null;
          selectedEndTime = null;
        } else {
          selectedTime = fetchedPreference.notificationStartTime;
          selectedEndTime = fetchedPreference.notificationEndTime;
          selectedDailyTime = null;
          selectedDailyEndTime = null;
        }
      }

      if (themeProvider.quoteThemesList
          .any((val) => val.id == preference?.themeId)) {
        selectedThemeId = preference?.themeId;
      }
    } catch (error) {
      CustomSnackBar.showError(message: error.toString());
    } finally {
      stopGetPreferenceLoading();
    }
  }

  int? selectedThemeId;

  setSelectedThemeId(int id) {
    selectedThemeId = id;
    notifyListeners();
  }
}
