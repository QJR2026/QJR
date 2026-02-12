class QuoteTheme {
  final int? id;
  final String? name;
  final String? description;

  QuoteTheme({
    this.id,
    this.name,
    this.description,
  });

  factory QuoteTheme.fromJson(Map<String, dynamic> json) {
    return QuoteTheme(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: (json['description'] as String?)?.trim(),
    );
  }

  // Convert QuoteTheme object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  static List<QuoteTheme> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => QuoteTheme.fromJson(json)).toList();
  }
}
