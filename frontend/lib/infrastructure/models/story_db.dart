class StoryDbResponse {
  final int id;
  final String title;
  final String syopsis;
  final bool publish;
  final String genre;
  final String? img;

  StoryDbResponse({
    required this.id,
    required this.title,
    required this.syopsis,
    required this.publish,
    required this.genre,
    this.img,
  });

  factory StoryDbResponse.fromJson(Map<String, dynamic> json) =>
      StoryDbResponse(
        id: json["id"],
        title: json["title"],
        syopsis: json["syopsis"],
        publish: json["publish"],
        genre: json["genre"],
        img: json["img"],
      );

  static List<StoryDbResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StoryDbResponse.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "syopsis": syopsis,
        "publish": publish,
        "genre": genre,
        "img": img,
      };
}
