import 'package:flutter/material.dart';

class Preference {
  int? id;
  int? userId;
  int? themeId;
  TimeOfDay? notificationStartTime;
  TimeOfDay? notificationEndTime;
  String? timezone;
  List<String>? days;
  bool isDaily;
  DateTime? createdAt;
  DateTime? updatedAt;

  Preference({
    this.id,
    this.userId,
    this.themeId,
    this.notificationStartTime,
    this.notificationEndTime,
    this.timezone,
    this.days,
    required this.isDaily,
    this.createdAt,
    this.updatedAt,
  });

  // factory Preference.fromJson(Map<String, dynamic> json) {
  //   List<String>? parsedDays =
  //       json['days'] != null ? (json['days'] as String).split(',') : null;
  //   bool isDaily = parsedDays?.contains('Daily') ?? false;
  //   TimeOfDay? notificationTime;
  //   if (json['notification_start_time'] != null) {
  //     DateTime utcTime =
  //         DateTime.parse("1970-01-01T${json['notification_start_time']}Z")
  //             .toUtc();
  //     DateTime localTime = utcTime.toLocal();
  //     notificationTime =
  //         TimeOfDay(hour: localTime.hour, minute: localTime.minute);
  //   }
  //   return Preference(
  //     id: json['id'] as int?,
  //     userId: json['user_id'] as int?,
  //     themeId: json['theme_id'] as int?,
  //     notificationTime: notificationTime,
  //     timezone: json['timezone'] as String?,
  //     days: isDaily ? null : parsedDays,
  //     isDaily: isDaily,
  //     createdAt: json['created_at'] != null
  //         ? DateTime.parse(json['created_at'])
  //         : null,
  //     updatedAt: json['updated_at'] != null
  //         ? DateTime.parse(json['updated_at'])
  //         : null,
  //   );
  // }
  factory Preference.fromJson(Map<String, dynamic> json) {
    // Helper function to parse TimeOfDay from a time string
    TimeOfDay? parseTimeOfDay(String? timeString) {
      if (timeString == null) return null;
      try {
        final utcTime = DateTime.parse("1970-01-01T${timeString}Z");
        final localTime = utcTime;
        return TimeOfDay(hour: localTime.hour, minute: localTime.minute);
      } catch (e) {
        print("Error parsing time: $timeString, error: $e");
        return null;
      }
    }

    // Parse days
    List<String>? parsedDays =
        json['days'] != null ? (json['days'] as String).split(',') : null;
    bool isDaily = parsedDays?.contains('Daily') ?? false;

    return Preference(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      themeId: json['theme_id'] as int?,
      notificationStartTime: parseTimeOfDay(json['notification_start_time']),
      notificationEndTime: parseTimeOfDay(json['notification_end_time']),
      timezone: json['timezone'] as String?,
      days: isDaily ? null : parsedDays,
      isDaily: isDaily,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme_id': themeId,
      'notification_start_time': notificationStartTime != null
          ? "${notificationStartTime!.hour.toString().padLeft(2, '0')}:${notificationStartTime!.minute.toString().padLeft(2, '0')}:00"
          : null,
      'notification_end_time': notificationEndTime != null
          ? "${notificationEndTime!.hour.toString().padLeft(2, '0')}:${notificationEndTime!.minute.toString().padLeft(2, '0')}:00"
          : null,
      'timezone': timezone,
      'days': isDaily ? null : days?.join(','),
      'is_daily': isDaily,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
