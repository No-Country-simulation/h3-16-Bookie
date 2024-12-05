import 'package:bookie/domain/entities/genre_entity.dart';

abstract class GenreDatasource {
  Future<List<Genre>> getGenres();
}
