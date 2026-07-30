/// Background image chosen for a theme: either one of the bundled "default"
/// SVGs (looked up by [id] in `defaultThemeImages`), a "custom" uploaded
/// image reachable at [src], or absent entirely (no image configured).
class QuoteThemeImage {
  final String type;
  final String? id;
  final String? src;

  const QuoteThemeImage({
    required this.type,
    this.id,
    this.src,
  });

  factory QuoteThemeImage.fromJson(Map<String, dynamic> json) {
    return QuoteThemeImage(
      type: json['type'] as String? ?? '',
      id: json['id'] as String?,
      src: json['src'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'id': id,
      'src': src,
    };
  }

  bool get isDefault => type == 'default';
  bool get isCustom => type == 'custom';
}

class QuoteTheme {
  final int? id;
  final String? name;
  final String? description;
  final bool isPopular;
  final QuoteThemeImage? image;
  final String? imageSource;
  final int? usedByCount;
  final int? usersLeft30;
  final int? qjrCount;

  /// ISO 8601 timestamp from the backend, e.g. "2026-07-30T09:41:55.000Z".
  final String? lastUpdated;

  QuoteTheme({
    this.id,
    this.name,
    this.description,
    this.isPopular = false,
    this.image,
    this.imageSource,
    this.usedByCount,
    this.usersLeft30,
    this.qjrCount,
    this.lastUpdated,
  });

  factory QuoteTheme.fromJson(Map<String, dynamic> json) {
    return QuoteTheme(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: (json['desc'] as String?)?.trim(),
      isPopular: json['popularTheme'] as bool? ?? false,
      image: json['image'] != null
          ? QuoteThemeImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      imageSource: json['imageSource'] as String?,
      usedByCount: json['usersUsing'] as int?,
      usersLeft30: json['usersLeft30'] as int?,
      qjrCount: json['totalQuotes'] as int?,
      lastUpdated: json['lastUpdated'] as String?,
    );
  }

  // Convert QuoteTheme object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': description,
      'popularTheme': isPopular,
      'image': image?.toMap(),
      'imageSource': imageSource,
      'usersUsing': usedByCount,
      'usersLeft30': usersLeft30,
      'totalQuotes': qjrCount,
      'lastUpdated': lastUpdated,
    };
  }

  static List<QuoteTheme> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => QuoteTheme.fromJson(json)).toList();
  }

  /// Human-readable "time ago" string, e.g. "Updated 3h ago".
  /// Returns null when [lastUpdated] is null, empty, or unparseable.
  String? get updatedAgoText {
    if (lastUpdated == null || lastUpdated!.isEmpty) return null;
    final date = DateTime.tryParse(lastUpdated!);
    if (date == null) return null;
    final diff = DateTime.now().difference(date.toLocal());
    final String ago;
    if (diff.inSeconds < 60) {
      ago = 'Just now';
    } else if (diff.inMinutes < 60) {
      ago = '${diff.inMinutes} mins ago';
    } else if (diff.inHours < 24) {
      ago = '${diff.inHours} hrs ago';
    } else if (diff.inDays < 7) {
      ago = '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      ago = '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays < 365) {
      ago = '${(diff.inDays / 30).floor()}mo ago';
    } else {
      ago = '${(diff.inDays / 365).floor()}y ago';
    }
    return 'Updated $ago';
  }
}

/// One page of the paginated get-all-themes response, along with enough
/// metadata to know whether there's another page to load.
class QuoteThemesPage {
  final List<QuoteTheme> themes;
  final int page;
  final int totalPages;
  final int total;

  const QuoteThemesPage({
    required this.themes,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  factory QuoteThemesPage.fromJson(
    Map<String, dynamic> json, {
    required int requestedPage,
  }) {
    final themes =
        QuoteTheme.fromJsonList(json['data'] as List<dynamic>? ?? []);
    final pagination = json['pagination'] as Map<String, dynamic>?;
    return QuoteThemesPage(
      themes: themes,
      page: pagination?['page'] as int? ?? requestedPage,
      totalPages: pagination?['totalPages'] as int? ?? 1,
      total: pagination?['total'] as int? ?? themes.length,
    );
  }

  bool get hasMore => page < totalPages;
}
