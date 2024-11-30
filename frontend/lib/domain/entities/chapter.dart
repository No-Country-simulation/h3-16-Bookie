class Chapter {
  final int id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final int historyId;

  Chapter({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.historyId,
  });
}

class ChapterForm {
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final int historyId;
  String? image;

  ChapterForm({
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.historyId,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "latitude": latitude,
      "longitude": longitude,
      "historyId": historyId,
      "image": image,
    };
  }
}
