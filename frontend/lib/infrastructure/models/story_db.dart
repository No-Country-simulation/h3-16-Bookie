import 'package:bookie/infrastructure/models/chapter_db.dart';
import 'package:bookie/infrastructure/models/user_db.dart';

class StoryDbResponse {
  final int id;
  final String title;
  final String syopsis;
  final UserDb? creatorId;
  final bool publish;
  final String genre;
  final String? country;
  final String? province;
  final String? img;
  final List<ChapterDbResponse> chapters;

  StoryDbResponse({
    required this.id,
    required this.title,
    required this.syopsis,
    required this.publish,
    required this.genre,
    required this.img,
    required this.chapters,
    this.creatorId,
    this.country,
    this.province,
  });

  factory StoryDbResponse.fromJson(Map<String, dynamic> json) {
    return StoryDbResponse(
      id: json["id"],
      title: json["title"],
      syopsis: json["syopsis"],
      publish: json["publish"],
      genre: json["genre"],
      img: json["img"],
      creatorId: json["creator_id"] == null
          ? null
          : UserDb.fromJson(json["creator_id"]),
      country: json["country"],
      province: json["province"],
      chapters: json["chapters"] == null
          ? []
          : List<ChapterDbResponse>.from(
              json["chapters"].map((x) => ChapterDbResponse.fromJson(x))),
    );
  }

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
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
        "creatorId": creatorId?.toJson(),
        "country": country,
        "province": province,
      };
}
