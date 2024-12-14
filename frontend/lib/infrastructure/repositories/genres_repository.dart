import 'package:bookie/domain/datasources/genre_datasource.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/domain/repositories/genre_repository.dart';

class GenresRepositoryImpl implements GenreRepository {
  final GenreDatasource datasource;

  GenresRepositoryImpl(this.datasource);

  @override
  Future<List<Genre>> getGenres() {
    return datasource.getGenres();
  }

  @override
  Future<List<Story>> getStoriesByGenreName(String genreName) {
    return datasource.getStoriesByGenreName(genreName);
  }
}
