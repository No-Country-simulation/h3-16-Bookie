import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';

abstract class GenreRepository {
  Future<List<Genre>> getGenres();

  Future<List<Story>> getStoriesByGenreName(String genreName);
}
