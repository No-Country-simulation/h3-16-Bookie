import 'package:bookie/domain/entities/chapter.dart';

abstract class ChapterRepository {
  Future<List<Chapter>> getChaptersByStoryId(int storyId);

  Future<Chapter> createChapter(ChapterForm chapterForm);
}
