import 'package:bookie/domain/entities/favorite_entity.dart';
import 'package:bookie/infrastructure/models/favorite_db.dart';

class FavoriteMapper {
  static Favorite favoriteDbToEntity(FavoriteDbResponse favoriteDbResponse) =>
      Favorite(
        id: favoriteDbResponse.id,
        story: FavoriteStory(
            id: favoriteDbResponse.histories?.id ?? 0,
            title: favoriteDbResponse.histories?.title ?? "",
            quantityChapters:
                favoriteDbResponse.histories?.chapters.length ?? 0,
            img: _resolveImageUrl(
                favoriteDbResponse.histories?.img ?? "sin-imagen")),
      );

  static String _resolveImageUrl(String? img) {
    return (img?.startsWith("http:") == true)
        ? "sin-imagen"
        : (img ?? "sin-imagen");
  }
}
