import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/datasources/genredb_datasource.dart';
import 'package:bookie/infrastructure/repositories/genres_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final genreRepositoryProvider = Provider((ref) {
  return GenresRepositoryImpl(GenreDbDatasource());
});

final getGenresProvider =
    StateNotifierProvider<GenreNotifier, List<Genre>>((ref) {
  final fetchGenres = ref.watch(genreRepositoryProvider).getGenres;

  return GenreNotifier(fetchGenre: fetchGenres);
});

typedef GenreCallback = Future<List<Genre>> Function();

class GenreNotifier extends StateNotifier<List<Genre>> {
  final GenreCallback fetchGenre;

  GenreNotifier({required this.fetchGenre}) : super([]);

  Future<void> loadGenres() async {
    final List<Genre> genres =
        await fetchGenre(); // Obtén las historias completas o las necesarias
    state = genres; // Actualiza el estado directamente con las historias
  }
}

final getStoriesByGenreNameProvider =
    FutureProvider.family.autoDispose<List<Story>, String>((ref, genreName) async {
  final repository = ref.watch(genreRepositoryProvider);
  return repository.getStoriesByGenreName(genreName);
});

// Estado para manejar el proveedor actual seleccionado
final filterGenreProvider =
    StateNotifierProvider<FilterStateNotifier, FilterGenreState>((ref) => FilterStateNotifier());

class FilterStateNotifier extends StateNotifier<FilterGenreState> {
  FilterStateNotifier() : super(FilterGenreState(null));

  void selectProvider(ProviderBase<AsyncValue<List<Story>>>? provider) {
    state = FilterGenreState(provider);
  }
}

class FilterGenreState {
  final ProviderBase<AsyncValue<List<Story>>>? provider;

  FilterGenreState(this.provider);
}