import 'package:bookie/domain/entities/chapter_local.dart';
import 'package:bookie/infrastructure/models/chapter_local.dart';

class ChapterMapper {
  static ChapterLocal storyLocalToEntity(ChapterLocalModel chapterLocal) {
    return ChapterLocal(
      id: int.parse(chapterLocal.id),
      title: chapterLocal.title,
      description: '',
      latitude: chapterLocal.latitude,
      longitude: chapterLocal.longitude,
      imageUrl: '',
      publish: false,
    );
  }
}
