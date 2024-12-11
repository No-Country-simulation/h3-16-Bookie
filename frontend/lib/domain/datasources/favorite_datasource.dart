
import 'package:bookie/domain/entities/favorite_entity.dart';

abstract class FavoriteDatasource {
  Future<List<Favorite>> getFavorites();

  Future<Favorite> addFavorite(FavoriteForm favoriteForm);

  Future<void> removeFavorite(int favoriteId);
}