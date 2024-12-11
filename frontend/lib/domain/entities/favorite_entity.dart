class Favorite {
  final int id;
  final FavoriteStory story;

  Favorite({
    required this.id,
    required this.story,
  });

  Favorite copyWith({
    int? id,
    FavoriteStory? story,
  }) {
    return Favorite(
      id: id ?? this.id,
      story: story ?? this.story,
    );
  }

  @override
  String toString() {
    return 'Favorite(id: $id, stories: ${story.img})';
  }
}

class FavoriteStory {
  final int id;
  final String title;
  final int quantityChapters;
  final String? img;

  FavoriteStory({
    required this.id,
    required this.title,
    required this.quantityChapters,
    this.img,
  });
}

class FavoriteForm {
  final int userId;
  final int historyId;

  FavoriteForm({
    required this.userId,
    required this.historyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "userID": userId,
      "historyID": historyId,
    };
  }
}
