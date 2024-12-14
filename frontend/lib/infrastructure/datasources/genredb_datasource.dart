import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/domain/datasources/genre_datasource.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/infrastructure/mappers/storydb_mapper.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class GenreDbDatasource extends GenreDatasource {
  @override
  Future<List<Genre>> getGenres() async {
    try {
      final response = await FetchApi.fetchDio().get('/v1/genre');

      // Verificar si la respuesta contiene una lista
      if (response.data is List) {
        // Mapear la lista de géneros
        final genres = (response.data as List).map((genre) {
          return GenreMapper.mapStringToEnum(genre);
        }).toList();

        // Retornar la lista de géneros
        return genres;
      } else {
        throw Exception("La respuesta no es una lista");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Story>> getStoriesByGenreName(String genreName) async {
    try {
      final response = await FetchApi.fetchDio().get(
        '/v1/history/by-genre?genre=$genreName',
      );

      final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

      final List<Story> stories =
          storiesDBResponse.map(StoryMapper.storyDbToEntity).toList();

      stories.removeWhere((story) => story.chapters.isEmpty);

      return stories;
    } catch (e) {
      rethrow;
    }
  }
}
