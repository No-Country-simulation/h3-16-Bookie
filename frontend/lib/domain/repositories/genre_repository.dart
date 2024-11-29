import 'package:bookie/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<List<Genre>> getGenres();
}
