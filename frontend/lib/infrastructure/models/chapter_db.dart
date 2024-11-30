class ChapterDbResponse {
  int id;
  String title;
  String content;
  double latitude;
  double longitude;
  int historyId;

  ChapterDbResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.historyId,
  });

  factory ChapterDbResponse.fromJson(Map<String, dynamic> json) => ChapterDbResponse(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        historyId: json["historyId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "latitude": latitude,
        "longitude": longitude,
        "historyId": historyId,
      };

  static List<ChapterDbResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChapterDbResponse.fromJson(json)).toList();
  }
}
