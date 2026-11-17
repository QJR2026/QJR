import 'package:flutter_test/flutter_test.dart';
import 'package:motivational/utils/device_info.dart';

void main() {
  group('validAndroidId', () {
    test('accepts and normalizes a real ANDROID_ID', () {
      expect(
          DeviceInfo.validAndroidId(' A1B2C3D4E5F6A7B8 '), 'a1b2c3d4e5f6a7b8');
    });

    test('accepts IDs shorter than 16 chars (leading zeros dropped)', () {
      expect(DeviceInfo.validAndroidId('1b2c3d4e5f6a7b8'), '1b2c3d4e5f6a7b8');
    });

    test('rejects null, empty, non-hex and the known-bad ID', () {
      expect(DeviceInfo.validAndroidId(null), isNull);
      expect(DeviceInfo.validAndroidId(''), isNull);
      expect(DeviceInfo.validAndroidId('not-an-id'), isNull);
      expect(DeviceInfo.validAndroidId('9774d56d682e549c'), isNull);
      expect(DeviceInfo.validAndroidId('9774D56D682E549C'), isNull);
    });
  });

  group('sanitizeLabel', () {
    test('keeps normal model names', () {
      expect(DeviceInfo.sanitizeLabel('SM-A546E'), 'SM-A546E');
    });

    test('replaces spaces and non-ASCII with underscores', () {
      expect(DeviceInfo.sanitizeLabel('Pixel 7 Pro'), 'Pixel_7_Pro');
      expect(DeviceInfo.sanitizeLabel('小米 13'), '13');
    });

    test('never returns empty and caps length', () {
      expect(DeviceInfo.sanitizeLabel('   '), 'unknown');
      expect(DeviceInfo.sanitizeLabel('x' * 100).length, 40);
    });
  });

  test('generateUuidV4 returns unique RFC 4122 v4 UUIDs', () {
    final pattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
    final ids = List.generate(1000, (_) => DeviceInfo.generateUuidV4());
    expect(ids.every(pattern.hasMatch), isTrue);
    expect(ids.toSet().length, ids.length);
  });

  group('chooseBase', () {
    const a = 'aaaaaaaaaaaaaaaa';
    const b = 'bbbbbbbbbbbbbbbb';
    const uuid = '11111111-2222-4333-8444-555555555555';
    String gen() => uuid;

    test('first launch uses ANDROID_ID', () {
      expect(
          DeviceInfo.chooseBase(
              stored: null, currentAndroidId: a, generate: gen),
          a);
    });

    test('first launch without ANDROID_ID uses a new UUID', () {
      expect(
          DeviceInfo.chooseBase(
              stored: null, currentAndroidId: null, generate: gen),
          uuid);
    });

    test('same device keeps the stored base', () {
      expect(
          DeviceInfo.chooseBase(
              stored: '$a|$a', currentAndroidId: a, generate: gen),
          a);
    });

    test('transient ANDROID_ID failure does not flip the ID', () {
      expect(
          DeviceInfo.chooseBase(
              stored: '$a|$a', currentAndroidId: null, generate: gen),
          a);
    });

    test('fallback UUID stays once chosen, even if ANDROID_ID appears later',
        () {
      expect(
          DeviceInfo.chooseBase(
              stored: '$uuid|', currentAndroidId: a, generate: gen),
          uuid);
    });

    test('prefs restored from another phone are ignored', () {
      expect(
          DeviceInfo.chooseBase(
              stored: '$a|$a', currentAndroidId: b, generate: gen),
          b);
    });

    test('malformed stored value is ignored', () {
      expect(
          DeviceInfo.chooseBase(
              stored: 'garbage', currentAndroidId: a, generate: gen),
          a);
      expect(
          DeviceInfo.chooseBase(
              stored: '|', currentAndroidId: null, generate: gen),
          uuid);
    });
  });
}
