import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<String?> getDeviceId() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.id}-${androidInfo.brand}-${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      print("Error retrieving device ID: $e");
    }
    return null; // Return null instead of an empty string to signal failure
  }
}
