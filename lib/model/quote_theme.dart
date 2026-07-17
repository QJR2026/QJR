class QuoteTheme {
  final int? id;
  final String? name;
  final String? description;
  final bool isPopular;
  final String? bgUrl;
  final int? usedByCount;
  final int? qjrCount;
  final DateTime? updatedAt;

  QuoteTheme({
    this.id,
    this.name,
    this.description,
    this.isPopular = false,
    this.bgUrl,
    this.usedByCount,
    this.qjrCount,
    this.updatedAt,
  });

  factory QuoteTheme.fromJson(Map<String, dynamic> json) {
    return QuoteTheme(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: (json['description'] as String?)?.trim(),
      isPopular: json['is_popular'] as bool? ?? false,
      bgUrl: (json['bg_url'] as String?)?.trim(),
      usedByCount: json['used_by_count'] as int?,
      qjrCount: json['qjr_count'] as int?,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }

  // Convert QuoteTheme object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_popular': isPopular,
      'bg_url': bgUrl,
      'used_by_count': usedByCount,
      'qjr_count': qjrCount,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static List<QuoteTheme> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => QuoteTheme.fromJson(json)).toList();
  }

  /// Human readable relative time, e.g. "2 hrs ago". Null when [updatedAt] is unknown.
  String? get updatedAgoText {
    final at = updatedAt;
    if (at == null) return null;

    final diff = DateTime.now().difference(at);
    if (diff.inSeconds < 60) return 'Updated just now';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return 'Updated $m min${m == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return 'Updated $h hr${h == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 30) {
      final d = diff.inDays;
      return 'Updated $d day${d == 1 ? '' : 's'} ago';
    }
    final months = (diff.inDays / 30).floor();
    return 'Updated $months month${months == 1 ? '' : 's'} ago';
  }
}
