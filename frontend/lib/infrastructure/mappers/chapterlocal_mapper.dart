import 'package:bookie/domain/entities/chapter.dart';
import 'package:bookie/infrastructure/models/chapter_local.dart';

class ChapterMapper {
  static Chapter storyLocalToEntity(ChapterLocal chapterLocal) {
    return Chapter(
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
