class News {
  final int id;
  final String type;
  final String? title;
  final String body;
  final String? imageUrl;

  const News({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      title: json['title'] as String?,
      body: json['body'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}
