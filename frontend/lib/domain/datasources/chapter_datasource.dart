import 'package:bookie/domain/entities/chapter_entity.dart';

abstract class ChapterDatasource {
  Future<List<Chapter>> getChaptersByStoryId(int storyId);

  Future<Chapter> createChapter(ChapterForm chapterForm);

  Future<Chapter> editChapter(ChapterForm chapterForm, int chapterId);
}
