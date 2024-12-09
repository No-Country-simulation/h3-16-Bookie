import 'package:bookie/domain/datasources/chapter_datasource.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/domain/repositories/chapter_repository.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  ChapterDatasource datasource;

  ChapterRepositoryImpl(this.datasource);

  @override
  Future<List<Chapter>> getChaptersByStoryId(int storyId) {
    return datasource.getChaptersByStoryId(storyId);
  }

  @override
  Future<Chapter> createChapter(ChapterForm chapterForm) {
    return datasource.createChapter(chapterForm);
  }

  @override
  Future<Chapter> editChapter(ChapterForm chapterForm, int chapterId) {
    return datasource.editChapter(chapterForm, chapterId);
  }
}
