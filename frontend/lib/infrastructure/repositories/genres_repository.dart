import 'package:bookie/domain/datasources/genre_datasource.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/repositories/genre_repository.dart';

class GenresRepositoryImpl implements GenreRepository {
  final GenreDatasource datasource;

  GenresRepositoryImpl(this.datasource);

  @override
  Future<List<Genre>> getGenres() {
    return datasource.getGenres();
  }
}
