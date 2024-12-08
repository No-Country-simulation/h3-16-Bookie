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

  // Future<void> toggleFavoriteAddOrRemove(int storyId) async {
  //   final favoriteFind = _returnFavorite(storyId);

  //   try {
  //     if (state.isEmpty || !isFavorite(storyId)) {
  //       final userId = await SharedPreferencesKeys.getCredentials()
  //           .then((value) => int.parse(value.id ?? '0'));

  //       final formFavorite = FavoriteForm(userId: userId, historyId: storyId);

  //       final favorite = await addFavoriteNotifier(formFavorite);

  //       state = [...state, favorite];
  //     } else {
  //       await removeFavoriteNotifier(favoriteFind.id);

  //       state =
  //           state.where((favorite) => favorite.id != favoriteFind.id).toList();
  //     }
  //   } catch (e) {
  //     throw Exception("No se puedo alternar el favorito");
  //   }
  // }

  // Favorite _returnFavorite(int storyId) {
  //   final favoriteFind = state.firstWhere(
  //       (element) => element.story.id == storyId,
  //       orElse: () => Favorite(
  //           id: -1,
  //           story: FavoriteStory(
  //               id: storyId,
  //               title: '',
  //               // TODO ARREGLAR EN EL CARD CLOSE STORIES PORQUE EN QUANTITY LO ESTABS COLOCANDO LAS DISTANCE VELO EN EL FAVORITE SCREEN SINO CREO OTRO CARD FAVORITE
  //               quantityChapters: 0,
  //               img: '')));

  //   return favoriteFind;
  // }

  // bool isFavorite(int storyId) {
  //   final favoriteFind = _returnFavorite(storyId);
  //   return favoriteFind.id != -1;
  // }
}
