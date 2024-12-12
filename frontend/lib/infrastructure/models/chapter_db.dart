class ChapterDbResponse {
  final int id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  int? historyId;
  String? image;

  ChapterDbResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    this.historyId,
    this.image,
  });

  factory ChapterDbResponse.fromJson(Map<String, dynamic> json) =>
      ChapterDbResponse(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        historyId: json["historyId"],
        image: json["image"] ?? json["img"],
      );

  static List<ChapterDbResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChapterDbResponse.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "latitude": latitude,
        "longitude": longitude,
        "historyId": historyId,
        "image": image,
      };
}
