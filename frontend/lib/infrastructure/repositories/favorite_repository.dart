import 'package:bookie/domain/datasources/favorite_datasource.dart';
import 'package:bookie/domain/entities/favorite_entity.dart';
import 'package:bookie/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  final FavoriteDatasource datasource;

  FavoriteRepositoryImpl(this.datasource);

  @override
  Future<List<Favorite>> getFavorites() {
    return datasource.getFavorites();
  }

  @override
  Future<Favorite> addFavorite(FavoriteForm favoriteForm) {
    return datasource.addFavorite(favoriteForm);
  }

  @override
  Future<void> removeFavorite(int favoriteId) {
    return datasource.removeFavorite(favoriteId);
  }
}
