import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  /// Converts TimeOfDay to "HH:mm" format (24-hour format)
  String to24HourFormat() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}
