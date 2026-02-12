import 'package:flutter_timezone/flutter_timezone.dart';

class TimeZone {
 static Future<String> timeZone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return currentTimeZone;
  }
}
