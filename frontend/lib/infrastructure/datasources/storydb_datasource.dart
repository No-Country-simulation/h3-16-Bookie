import 'package:bookie/config/fetch/fetch_api.dart';
// import 'package:bookie/config/helpers/sorted.dart';
import 'package:bookie/domain/datasources/story_datasource.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/storydb_mapper.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class StoriesDbDatasource extends StoriesDatasource {
  @override
  Future<List<Story>> getStories() async {
    try {
      final response = await FetchApi.fetchDio().get('/v1/history/all');
      final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

      final List<Story> stories =
          storiesDBResponse.map(StoryMapper.storyDbToEntity).toList();

      return stories;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Story>> getStoriesByUser(int userId) async {
    final response = await FetchApi.fetchDio().get('/v1/history/user/$userId');
    final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

    final List<Story> stories =
        storiesDBResponse.map(StoryMapper.storyDbToEntity).toList();

    return stories;
  }

  @override
  Future<Story> getStory(int storyId) async {
    final response = await FetchApi.fetchDio().get('/v1/history/$storyId');

    final storyDBResponse = StoryDbResponse.fromJson(response.data);

    final Story story = StoryMapper.storyDbToEntity(storyDBResponse);

    return story;
  }

  @override
  Future<Story> createStory(StoryForm storyForm) async {
    final response = await FetchApi.fetchDio().post(
      '/v1/history',
      data: storyForm.toJson(),
    );

    final storyDBResponse = StoryDbResponse.fromJson(response.data);

    final Story story = StoryMapper.storyDbToEntity(storyDBResponse);

    return story;
  }

  @override
  Future<void> deleteStory(int storyId) async {
    try {
      await FetchApi.fetchDio().delete(
        '/v1/history/$storyId',
      );
    } catch (e) {
      throw Exception("Error al eliminar historia");
    }
  }
}
