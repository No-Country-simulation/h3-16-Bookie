import 'package:bookie/config/constants/general.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class StoryMapper {
  static Story storyDBToEntity(StoryDbResponse storyDbResponse) {
    return Story(
      id: storyDbResponse.id,
      title: storyDbResponse.title,
      synopsis: storyDbResponse.syopsis,
      publish: storyDbResponse.publish,
      img: storyDbResponse.img ??
          GeneralConstants.imageNotFound, // Si no hay imagen, muestra un error
      // genre: storyDbResponse.genre,
    );
  }
}
