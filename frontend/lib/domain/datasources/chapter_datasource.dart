import 'package:bookie/domain/entities/chapter.dart';

abstract class ChapterDatasource {
  Future<List<Chapter>> getChaptersByStoryId(int storyId);

  Future<Chapter> createChapter(ChapterForm chapterForm);
}
