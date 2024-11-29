import 'package:bookie/domain/entities/genre.dart';

abstract class GenreDatasource {
  Future<List<Genre>> getGenres();
}
