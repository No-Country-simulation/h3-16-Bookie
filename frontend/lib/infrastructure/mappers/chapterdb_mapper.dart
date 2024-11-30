import 'package:bookie/domain/entities/chapter.dart';
import 'package:bookie/infrastructure/models/chapter_db.dart';

class ChapterDbMapper {
  static Chapter chapterToEntity(ChapterDbResponse chapterLocal) {
    return Chapter(
      id: chapterLocal.id,
      title: chapterLocal.title,
      content: chapterLocal.content,
      latitude: chapterLocal.latitude,
      longitude: chapterLocal.longitude,
      historyId: chapterLocal.historyId,
    );
  }
}