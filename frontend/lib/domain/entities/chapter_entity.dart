class ChapterPartial {
  final int id;
  final String title;
  final double latitude;
  final double longitude;
  String? image;

  ChapterPartial({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
      "image": image
    };
  }
}

class Chapter extends ChapterPartial {
  final String content;
  int? historyId;

  Chapter({
    required this.content,
    required super.id,
    required super.title,
    required super.latitude,
    required super.longitude,
    this.historyId,
    super.image,
  });

  @override
  String toString() {
    return 'Chapter(id: $id, title: $title, content: $content, historyId: $historyId, latitude: $latitude, longitude: $longitude, image: $image)';
  }
}

class ChapterForm {
  final int historyId;
  final String content;
  final String title;
  final double latitude;
  final double longitude;
  String? image;

  ChapterForm({
    required this.historyId,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.content,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "historyId": historyId,
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
      "content": content,
      "image": image
    };
  }
}
