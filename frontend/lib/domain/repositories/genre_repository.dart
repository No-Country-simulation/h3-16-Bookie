import 'package:bookie/domain/entities/genre_entity.dart';

abstract class GenreRepository {
  Future<List<Genre>> getGenres();
}
