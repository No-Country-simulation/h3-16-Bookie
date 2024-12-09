import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/domain/datasources/chapter_datasource.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/infrastructure/mappers/chapterdb_mapper.dart';
import 'package:bookie/infrastructure/models/chapter_db.dart';

class ChapterDbDatasource extends ChapterDatasource {
  @override
  Future<List<Chapter>> getChaptersByStoryId(int storyId) async {
    final response =
        await FetchApi.fetchDio().get('/v1/chapters/history/$storyId');

    final chaptersDBResponse = ChapterDbResponse.fromJsonList(response.data);

    final List<Chapter> chapters = chaptersDBResponse
        // .where((chapter) => chapter.campoafiltrar)
        .map((chapterdb) => ChapterMapper.chapterToEntity(chapterdb))
        .toList();

    return chapters;
  }

  @override
  Future<Chapter> createChapter(ChapterForm chapterForm) async {
    final response = await FetchApi.fetchDio().post(
      '/v1/chapters',
      data: chapterForm.toJson(),
    );

    final chapterDBResponse = ChapterDbResponse.fromJson(response.data);

    final Chapter chapter = ChapterMapper.chapterToEntity(chapterDBResponse);

    return chapter;
  }

  @override
  Future<Chapter> editChapter(ChapterForm chapterForm, int chapterId) async {
    final response = await FetchApi.fetchDio().put(
      '/v1/chapters/$chapterId',
      data: chapterForm.toJson(),
    );

    final chapterDBResponse = ChapterDbResponse.fromJson(response.data);

    final Chapter chapter = ChapterMapper.chapterToEntity(chapterDBResponse);

    return chapter;
  }
}
