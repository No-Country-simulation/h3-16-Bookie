import 'dart:math';

import 'package:bookie/config/constants/general.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/mappers/chapterlocal_mapper.dart';
import 'package:bookie/infrastructure/models/chapter_local.dart';
import 'package:bookie/infrastructure/models/story_db.dart';
import 'package:bookie/shared/data/histories.dart';

class StoryMapper {
  static final Random _random = Random(); // Instancia de Random

  static Story storyDBToEntity(StoryDbResponse storyDbResponse) {
    return Story(
        id: storyDbResponse.id,
        title: storyDbResponse.title,
        synopsis: storyDbResponse.syopsis,
        publish: storyDbResponse.publish,
        distance: 0,
        isFavorite: _random.nextBool(), // Genera true o false aleatoriamente
        imageUrl: storyDbResponse.img ??
            GeneralConstants
                .imageNotFound, // Si no hay imagen, muestra un error
        // genre: storyDbResponse.genre,
        chapters: chapters.map((chapter) {
          return ChapterMapper.storyLocalToEntity(
              ChapterLocal.fromJson(chapter));
        }).toList());
  }
}
