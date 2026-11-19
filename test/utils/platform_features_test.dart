import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motivational/utils/platform_features.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('subscriptions are enabled on iOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(PlatformFeatures.isSubscriptionEnabled, isTrue);
  });

  test('subscriptions are disabled on Android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(PlatformFeatures.isSubscriptionEnabled, isFalse);
  });

  test('isAndroid is true only on Android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(PlatformFeatures.isAndroid, isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(PlatformFeatures.isAndroid, isFalse);
  });
}
