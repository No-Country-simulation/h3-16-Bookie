import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/entities/favorite_entity.dart';
import 'package:bookie/infrastructure/datasources/favoritedb_datasource.dart';
import 'package:bookie/infrastructure/repositories/favorite_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteRepositoryProvider = Provider((ref) {
  return FavoriteRepositoryImpl(FavoritedbDatasource());
});

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Favorite>>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);

  return FavoriteNotifier(
    getFavoritesNotifier: repository.getFavorites,
    addFavoriteNotifier: repository.addFavorite,
    removeFavoriteNotifier: repository.removeFavorite,
  );
});

class FavoriteNotifier extends StateNotifier<List<Favorite>> {
  final Future<List<Favorite>> Function() getFavoritesNotifier;
  final Future<Favorite> Function(FavoriteForm favoriteForm)
      addFavoriteNotifier;
  final Future<void> Function(int favoriteId) removeFavoriteNotifier;

  FavoriteNotifier(
      {required this.getFavoritesNotifier,
      required this.addFavoriteNotifier,
      required this.removeFavoriteNotifier})
      : super([]);

  // Método para obtener todos los favoritos
  Future<List<Favorite>> getFavorites() async {
    try {
      final List<Favorite> favorites = await getFavoritesNotifier();
      state = favorites; // Actualiza el estado con los favoritos obtenidos
      return favorites;
    } catch (e) {
      return [];
    }
  }

  // Método para limpiar el estado de las historias al cerrar sesión
  void clearStoriesOnLogout() {
    state = []; // Reinicia el estado a su valor inicial
  }

  Future<void> addFavorite(int storyId) async {
    try {
      final userId = await SharedPreferencesKeys.getCredentials()
          .then((value) => int.parse(value.id ?? '0'));

      final formFavorite = FavoriteForm(userId: userId, historyId: storyId);

      final favorite = await addFavoriteNotifier(formFavorite);

      state = [...state, favorite];

      await getFavorites();
    } catch (e) {
      throw Exception("No se puede agregar el favorito");
    }
  }

  Future<void> removeFavorite(int storyId) async {
    try {
      final favoriteId =
          state.firstWhere((element) => element.story.id == storyId).id;
      await removeFavoriteNotifier(favoriteId);
      state = state.where((favorite) => favorite.id != favoriteId).toList();
    } catch (e) {
      throw Exception("No se puede eliminar el favorito");
    }
  }
}
