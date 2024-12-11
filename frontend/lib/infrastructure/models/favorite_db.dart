import 'package:bookie/infrastructure/models/story_db.dart';
import 'package:bookie/infrastructure/models/user_db.dart';

class FavoriteDbResponse {
  final int id;
  final StoryDbResponse? histories;
  final UserDb? userID;
  final StoryDbResponse? historyID;

  FavoriteDbResponse({
    required this.id,
    required this.histories,
    this.userID,
    this.historyID,
  });

  factory FavoriteDbResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteDbResponse(
      id: json["id"],
      histories: json["histories"] == null
          ? null
          : StoryDbResponse.fromJson(json["histories"]),
      userID: json["user_id"] == null ? null : UserDb.fromJson(json["user_id"]),
      historyID: json["history_id"] == null
          ? null
          : StoryDbResponse.fromJson(json["history_id"]),
    );
  }

  static List<FavoriteDbResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FavoriteDbResponse.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "histories": histories?.toJson(),
        "user_id": userID?.toJson(),
        "history_id": historyID?.toJson(),
      };
}
