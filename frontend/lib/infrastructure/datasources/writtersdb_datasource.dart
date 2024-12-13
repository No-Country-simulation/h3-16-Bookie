class WritterDb {
  final int id;
  final String name;
  final String email;
  final List<WritterHistory> histories;

  WritterDb({
    required this.id,
    required this.name,
    required this.email,
    required this.histories,
  });

  factory WritterDb.fromJson(Map<String, dynamic> json) => WritterDb(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        histories: List<WritterHistory>.from(
            json["histories"].map((x) => WritterHistory.fromJson(x))),
      );

  static List<WritterDb> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => WritterDb.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "histories": List<dynamic>.from(histories.map((x) => x.toJson())),
      };
}

class WritterHistory {
  final int id;
  final String title;
  final String synopsis;
  final String? img;
  final List<WritterChapter> chapters;

  WritterHistory({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.img,
    required this.chapters,
  });

  factory WritterHistory.fromJson(Map<String, dynamic> json) => WritterHistory(
        id: json["id"],
        title: json["title"],
        synopsis: json["synopsis"],
        img: json["img"],
        chapters: List<WritterChapter>.from(
            json["chapters"].map((x) => WritterChapter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "synopsis": synopsis,
        "img": img,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
      };
}

class WritterChapter {
  final int id;
  final String title;
  final String content;
  final String? img;

  WritterChapter({
    required this.id,
    required this.title,
    required this.content,
    required this.img,
  });

  factory WritterChapter.fromJson(Map<String, dynamic> json) => WritterChapter(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "img": img,
      };
}
