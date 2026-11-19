import 'package:flutter/foundation.dart';

/// Platform-level feature switches.
class PlatformFeatures {
  PlatformFeatures._();

  /// In-app subscriptions are offered only on iOS. The Android build is free,
  /// so the paywall, purchase checks and "Payment Plan" entry are skipped there.
  ///
  /// Uses [defaultTargetPlatform] instead of `dart:io` so it is web-safe and
  /// can be overridden in tests via `debugDefaultTargetPlatformOverride`.
  static bool get isSubscriptionEnabled =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// True on the Android app; used to tag API requests with `x-platform`.
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
}
