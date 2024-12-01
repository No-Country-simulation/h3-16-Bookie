import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/config/helpers/sorted.dart';
import 'package:bookie/domain/datasources/story_datasource.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/mappers/storydb_mapper.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class StoriesDbDatasource extends StoriesDatasource {
  @override
  Future<List<Story>> getStories() async {
    try {
      final response = await FetchApi.fetchDio().get('/v1/history/all');
      final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

      final List<Story> stories = storiesDBResponse
          // .where((story) => story.campoafiltrar)
          .map((storydb) => StoryMapper.storyDBToEntity(storydb))
          .toList();

      // Ordenar las historias por la distancia
      final List<Story> sortedStories = await getSortedStories(
          stories); // Ordenar las historias por la distancia

      return sortedStories;
    } catch (e) {
      print("Error al obtener las historias: $e");
      return [];
    }
  }

  @override
  Future<List<Story>> getStoriesByUser(int userId) async {
    final response = await FetchApi.fetchDio().get('/v1/history/user/$userId');
    final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

    final List<Story> stories = storiesDBResponse
        // .where((story) => story.campoafiltrar)
        .map((storydb) => StoryMapper.storyDBToEntity(storydb))
        .toList();

    // Ordenar las historias por la distancia
    final List<Story> sortedStories = await getSortedStories(
        stories); // Ordenar las historias por la distancia

    return sortedStories;
  }

  @override
  Future<Story> getStory(int storyId) async {
    print("Obteniendo historia con id: $storyId");

    final response = await FetchApi.fetchDio().get('/v1/history/$storyId');
    print("Respuesta de la API: ${response.data}");

    final storyDBResponse = StoryDbResponse.fromJson(response.data);

    final Story story = StoryMapper.storyDBToEntity(storyDBResponse);

    return story;
  }

  @override
  Future<Story> createStory(StoryForm storyForm) async {
    // print("Datos de la historia a crear: ${storyForm.toJson()}");

    final response = await FetchApi.fetchDio().post(
      '/v1/history',
      data: storyForm.toJson(),
    );

    final storyDBResponse = StoryDbResponse.fromJson(response.data);

    final Story story = StoryMapper.storyDBToEntity(storyDBResponse);

    return story;
  }

  @override
  Future<void> deleteStory(int storyId) async {
    try {
      print("Eliminando historia con id: $storyId");

      final response = await FetchApi.fetchDio().delete(
        '/v1/history/$storyId',
      );

      print("Respuesta de la API: ${response.data}");
    } catch (e) {
      print("Error al eliminar historia: $e");
      throw Exception("Error al eliminar historia");
    }
  }
}
