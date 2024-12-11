import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/datasources/favorite_datasource.dart';
import 'package:bookie/domain/entities/favorite_entity.dart';
import 'package:bookie/infrastructure/mappers/favoritedb_mapper.dart';
import 'package:bookie/infrastructure/models/favorite_db.dart';

class FavoritedbDatasource extends FavoriteDatasource {
  @override
  Future<List<Favorite>> getFavorites() async {
    try {
      final userId = await SharedPreferencesKeys.getCredentials()
          .then((value) => int.parse(value.id ?? '0'));

      final response =
          await FetchApi.fetchDio().get('/v1/wishlist/user/$userId');

      final favoriteDBResponse = FavoriteDbResponse.fromJsonList(response.data);

      final List<Favorite> favorites = favoriteDBResponse
          .map((favoritedb) => FavoriteMapper.favoriteDbToEntity(favoritedb))
          .toList();

      return favorites;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Favorite> addFavorite(FavoriteForm favoriteForm) async {
    try {
      final response = await FetchApi.fetchDio().post(
        '/v1/wishlist',
        data: favoriteForm.toJson(),
      );

      final favoriteDBResponse = FavoriteDbResponse.fromJson(response.data);

      final Favorite favorite =
          FavoriteMapper.favoriteDbToEntity(favoriteDBResponse);

      return favorite;
    } catch (e) {
      throw Exception("Error al agregar favorito");
    }
  }

  @override
  Future<void> removeFavorite(int favoriteId) async {
    try {
      await FetchApi.fetchDio().delete(
        '/v1/wishlist/$favoriteId',
      );
    } catch (e) {
      throw Exception("Error al quitar el favorito $e");
    }
  }
}
