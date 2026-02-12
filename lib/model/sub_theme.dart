class SubTheme {
  final int? id;
  final String description;
  final bool isLiked;

  SubTheme({
    this.id,
    required this.description,
    required this.isLiked,
  });

  String subDesctiption({int length = 40}) {
    final des = description.trim();
    if (des.length > length) {
      return '${des.substring(0, length)}...”';
    }
    return des;
  }

  factory SubTheme.fromJson(Map<String, dynamic> json) {
    return SubTheme(
      id: json['id'] as int?,
      description: (json['description'] ?? '').toString().trim(),
      isLiked: json['isLiked'] == 1 ? true : false,
    );
  }

  SubTheme copyWith({
    int? id,
    String? description,
    bool? isLiked,
  }) {
    return SubTheme(
      id: id ?? this.id,
      description: description ?? this.description,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'isLiked': isLiked,
    };
  }

  static List<SubTheme> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SubTheme.fromJson(json)).toList();
  }
}
