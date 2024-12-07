import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/chapterdb_mapper.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/infrastructure/mappers/userdb_mapper.dart';
import 'package:bookie/infrastructure/models/story_db.dart';
import 'package:bookie/infrastructure/models/user_db.dart';

class StoryMapper {
  static Story storyDbToEntity(StoryDbResponse storyDbResponse) {
    return Story(
      id: storyDbResponse.id,
      title: storyDbResponse.title,
      synopsis: storyDbResponse.syopsis,
      publish: storyDbResponse.publish,
      distance: 0,
      imageUrl: _resolveImageUrl(storyDbResponse.img),
      genre: GenreMapper.mapStringToEnum(storyDbResponse.genre),
      country: storyDbResponse.country ?? "TEMPORAL",
      province: storyDbResponse.province ?? "TEMPORAL",
      chapters: storyDbResponse.chapters
          .map(ChapterMapper.chapterToStoryAllEntity)
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id)),
      writer: UserMapper.userDbToEntity(UserDb(
        id: storyDbResponse.creatorId?.id ?? 0,
        name: storyDbResponse.creatorId?.name ?? "Autor desconocido",
        email: storyDbResponse.creatorId?.email ?? "user@email.com",
        auth0UserId: storyDbResponse.creatorId?.auth0UserId ?? "0",
        wishlist: storyDbResponse.creatorId?.wishlist ?? [],
      )),
    );
  }

  static String _resolveImageUrl(String? img) {
    return (img?.startsWith("http:") == true)
        ? "sin-imagen"
        : (img ?? "sin-imagen");
  }
}
