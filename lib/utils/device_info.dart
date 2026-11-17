import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import '../services/shared_preference_service.dart';

class DeviceInfo {
  DeviceInfo._();

  /// SharedPreferences key for the Android ID base record.
  /// Must survive logout — see `AuthRepository.clearPreferences`.
  static const installIdKey = 'device_install_id';

  /// Cached after the first successful lookup — it is read on every API request.
  static String? _cachedId;

  /// Shared in-flight Android lookup, so concurrent first calls (several API
  /// requests at startup) never resolve — or generate — two different IDs.
  static Future<String>? _androidLookup;

  /// Returns a stable, per-device identifier, or `null` if it can't be read.
  ///
  /// - Android: `<base>-<brand>-<model>`, where `<base>` is
  ///   `Settings.Secure.ANDROID_ID` (unique per device + user + app signing
  ///   key, survives uninstall/reinstall, resets on factory reset). If that is
  ///   unavailable or known-bad, a random UUID is used instead, so the ID never
  ///   collides with other devices. The chosen base is persisted (see
  ///   [chooseBase]) so it stays the same across launches and logout.
  /// - iOS: `identifierForVendor`.
  static Future<String?> getDeviceId() async {
    if (_cachedId != null) return _cachedId;

    try {
      if (Platform.isAndroid) {
        _cachedId = await (_androidLookup ??= _resolveAndroidId());
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        _cachedId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Error retrieving device ID: $e");
    }
    return _cachedId;
  }

  /// Never throws: every platform call degrades to a safe fallback.
  static Future<String> _resolveAndroidId() async {
    String? rawAndroidId;
    try {
      rawAndroidId = await const AndroidId().getId();
    } catch (e) {
      // e.g. MissingPluginException.
      debugPrint("Error retrieving ANDROID_ID: $e");
    }
    final base = await _resolveBase(validAndroidId(rawAndroidId));

    var brand = '';
    var model = '';
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      brand = info.brand;
      model = info.model;
    } catch (e) {
      debugPrint("Error retrieving device model: $e");
    }
    return '$base-${sanitizeLabel(brand)}-${sanitizeLabel(model)}';
  }

  /// Picks the ID base once per install and keeps it stable across launches
  /// and logout. Stored as `<base>|<ANDROID_ID seen when it was chosen>`.
  static Future<String> _resolveBase(String? currentAndroidId) async {
    final prefs = SharedPreferencesService();
    String? stored;
    try {
      stored = prefs.getString(installIdKey);
    } catch (e) {
      debugPrint("Error reading install ID: $e");
    }

    final base = chooseBase(
      stored: stored,
      currentAndroidId: currentAndroidId,
      generate: generateUuidV4,
    );

    final record = '$base|${currentAndroidId ?? _seenFor(stored, base)}';
    if (record != stored) {
      try {
        await prefs.setString(installIdKey, record);
      } catch (e) {
        debugPrint("Error saving install ID: $e");
      }
    }
    return base;
  }

  /// Keeps the previously seen ANDROID_ID when today's lookup failed.
  static String _seenFor(String? stored, String base) {
    final parts = stored?.split('|');
    return (parts != null && parts.length == 2 && parts[0] == base)
        ? parts[1]
        : '';
  }

  /// Decides which ID base to use.
  ///
  /// - Stored record and ANDROID_ID unavailable now → stored base (no flip on a
  ///   transient failure).
  /// - Stored record made on this same ANDROID_ID, or made from the fallback →
  ///   stored base (stable).
  /// - Stored record made on a *different* ANDROID_ID → the prefs were
  ///   restored from another phone (Android Auto Backup), so it is ignored to
  ///   avoid two devices sharing one ID.
  /// - Nothing usable stored → current ANDROID_ID, else a new random UUID.
  @visibleForTesting
  static String chooseBase({
    required String? stored,
    required String? currentAndroidId,
    required String Function() generate,
  }) {
    final parts = stored?.split('|');
    if (parts != null && parts.length == 2 && parts[0].isNotEmpty) {
      final storedBase = parts[0];
      final seen = parts[1];
      final sameDevice = currentAndroidId == null ||
          seen.isEmpty ||
          seen == currentAndroidId;
      if (sameDevice) return storedBase;
    }
    return currentAndroidId ?? generate();
  }

  /// Known-bad ANDROID_ID shared by every device on some old Android 2.2 builds.
  static const _brokenAndroidId = '9774d56d682e549c';
  static final _androidIdPattern = RegExp(r'^[0-9a-f]{8,16}$');

  /// Normalized ANDROID_ID, or `null` if it is missing or known-bad.
  @visibleForTesting
  static String? validAndroidId(String? raw) {
    final value = raw?.trim().toLowerCase();
    if (value == null ||
        value == _brokenAndroidId ||
        !_androidIdPattern.hasMatch(value)) {
      return null;
    }
    return value;
  }

  /// Makes a brand/model string safe for an HTTP header value: ASCII only,
  /// spaces and symbols collapsed to `_`, max 40 chars, never empty.
  @visibleForTesting
  static String sanitizeLabel(String value) {
    var clean = value
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    if (clean.length > 40) clean = clean.substring(0, 40);
    return clean.isEmpty ? 'unknown' : clean;
  }

  /// RFC 4122 version-4 UUID from a cryptographically secure RNG.
  @visibleForTesting
  static String generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // RFC 4122 variant

    final h = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}
