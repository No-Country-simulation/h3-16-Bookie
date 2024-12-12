class Read {
  final int id;
  final ReadStory story;
  final List<ReadChapterComplete> readChapters;

  Read({
    required this.id,
    required this.story,
    required this.readChapters,
  });

  @override
  String toString() {
    return 'Read{id: $id, story: $story, chapters: $readChapters}';
  }
}

class ReadStory {
  final int id;
  final String title;
  final bool completeStory;
  final List<ReadChapter> chapters;

  ReadStory({
    required this.id,
    required this.title,
    required this.completeStory,
    required this.chapters,
  });
}

class ReadChapter {
  final int id;
  final String title;
  final String? image;

  ReadChapter({
    required this.id,
    required this.title,
    this.image,
  });

  @override
  String toString() {
    return 'ReadChapter{id: $id, title: $title, image: $image}';
  }
}

class ReadChapterComplete {
  final ReadChapter readChapter;
  final bool completeChapter;

  ReadChapterComplete({
    required this.readChapter,
    required this.completeChapter,
  });

  @override
  String toString() {
    return 'ReadChapterComplete{readChapter: $readChapter, completeChapter: $completeChapter}';
  }
}

class ReadForm {
  final int userId;
  final int historyId;

  ReadForm({
    required this.userId,
    required this.historyId,
  });

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "history_id": historyId,
      };
}

class ReadChapterForm {
  final int chapterId;
  final int readerId;

  ReadChapterForm({
    required this.chapterId,
    required this.readerId,
  });

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "readerId": readerId,
      };
}
