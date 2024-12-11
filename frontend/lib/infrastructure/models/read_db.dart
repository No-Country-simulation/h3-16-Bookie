import 'package:bookie/infrastructure/models/chapter_db.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class ReadDbResponse {
  final int id;
  final ReadUserDbResponse user;
  final StoryDbResponse history;
  final bool complete;
  final List<ReadChapterDbResponse> readerChapters;

  ReadDbResponse({
    required this.id,
    required this.user,
    required this.history,
    required this.complete,
    required this.readerChapters,
  });

  factory ReadDbResponse.fromJson(Map<String, dynamic> json) => ReadDbResponse(
        id: json["id"],
        user: ReadUserDbResponse.fromJson(json["user"]),
        history: StoryDbResponse.fromJson(json["history"]),
        complete: json["complete"],
        readerChapters: List<ReadChapterDbResponse>.from(
            json["readerChapters"].map((x) => ReadChapterDbResponse.fromJson(x))),
      );

  static List<ReadDbResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ReadDbResponse.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "history": history.toJson(),
        "complete": complete,
        "readerChapters": List<dynamic>.from(readerChapters.map((x) => x)),
      };

  @override
  String toString() {
    return 'ReadDbResponse{id: $id, user: $user, history: $history, complete: $complete, readerChapters: $readerChapters}';
  }
}

class ReadUserDbResponse {
  final int id;
  final String name;

  ReadUserDbResponse({
    required this.id,
    required this.name,
  });

  factory ReadUserDbResponse.fromJson(Map<String, dynamic> json) =>
      ReadUserDbResponse(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ReadChapterDbResponse {
  final ChapterDbResponse chapter;
  final bool complete;

  ReadChapterDbResponse({
    required this.chapter,
    required this.complete,
  });

  factory ReadChapterDbResponse.fromJson(Map<String, dynamic> json) =>
      ReadChapterDbResponse(
        chapter: ChapterDbResponse.fromJson(json["chapter"]),
        complete: json["complete"],
      );

  Map<String, dynamic> toJson() => {
        "chapter": chapter.toJson(),
        "complete": complete,
      };
}