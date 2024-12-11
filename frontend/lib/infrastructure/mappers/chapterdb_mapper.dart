import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/infrastructure/models/chapter_db.dart';

class ChapterMapper {
  static Chapter chapterToEntity(ChapterDbResponse chapter) {
    return Chapter(
      id: chapter.id,
      title: chapter.title,
      content: chapter.content,
      latitude: chapter.latitude,
      longitude: chapter.longitude,
      historyId: chapter.historyId ?? 1, 
      image: _resolveImageUrl(chapter.image),
    );
  }

  static ChapterPartial chapterToStoryAllEntity(ChapterDbResponse chapter) {
    return ChapterPartial(
      id: chapter.id,
      latitude: chapter.latitude,
      longitude: chapter.longitude,
      title: chapter.title,
      image: _resolveImageUrl(chapter.image),
    );
  }

  static String _resolveImageUrl(String? img) {
    return (img?.startsWith("http:") == true)
        ? "sin-imagen"
        : (img ?? "sin-imagen");
  }
}
