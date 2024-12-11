import 'package:bookie/domain/entities/read_entity.dart';
import 'package:bookie/infrastructure/models/read_db.dart';

class ReadMapper {
  static Read readDbToEntity(ReadDbResponse readDbResponse) => Read(
        id: readDbResponse.id,
        story: ReadStory(
            id: readDbResponse.history.id,
            title: readDbResponse.history.title,
            completeStory: readDbResponse.complete,
            chapters: readDbResponse.history.chapters.map((chapter) {
              return ReadChapter(
                id: chapter.id,
                title: chapter.title,
                image: _resolveImageUrl(chapter.image),
              );
            }).toList()),
        readChapters: readDbResponse.readerChapters.map((chapter) {
          return ReadChapterComplete(
            readChapter: ReadChapter(
              id: chapter.chapter.id,
              title: chapter.chapter.title,
              image: _resolveImageUrl(chapter.chapter.image),
            ),
            completeChapter: chapter.complete,
          );
        }).toList(),
      );

  static String _resolveImageUrl(String? img) {
    return (img?.startsWith("http:") == true)
        ? "sin-imagen"
        : (img ?? "sin-imagen");
  }
}
