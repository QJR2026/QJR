class PresignedUpload {
  final String uploadUrl;
  final String imageUrl;
  final String key;

  const PresignedUpload({
    required this.uploadUrl,
    required this.imageUrl,
    required this.key,
  });

  factory PresignedUpload.fromJson(Map<String, dynamic> json) {
    return PresignedUpload(
      uploadUrl: json['uploadUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      key: json['key'] as String,
    );
  }
}
