import '/model/sub_theme.dart';
import '/model/quote_theme.dart';

class NotificationSubTheme {
  final int? id;
  final QuoteTheme theme;
  final SubTheme subtheme;
  final String? createdAt;

  NotificationSubTheme({
    this.id,
    required this.theme,
    required this.subtheme,
    required this.createdAt,
  });

  factory NotificationSubTheme.fromJson(Map<String, dynamic> json) {
    return NotificationSubTheme(
      id: json['id'] as int?,
      theme: QuoteTheme.fromJson(json['theme'] as Map<String, dynamic>),
      subtheme: SubTheme.fromJson(json['subTheme'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );
  }

  static List<NotificationSubTheme> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NotificationSubTheme.fromJson(json)).toList();
  }

  NotificationSubTheme copyWith({
    int? id,
    QuoteTheme? theme,
    SubTheme? subtheme,
    String? createdAt,
  }) {
    return NotificationSubTheme(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      subtheme: subtheme ?? this.subtheme,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
