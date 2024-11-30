import 'package:bookie/domain/entities/chapter.dart';
import 'package:bookie/infrastructure/datasources/chapterdb_datasource.dart';
import 'package:bookie/infrastructure/repositories/chapter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chapterRepositoryProvider = Provider((ref) {
  return ChapterRepositoryImpl(ChapterDbDatasource());
});

final chapterProvider =
    StateNotifierProvider<ChapterNotifier, List<Chapter>>((ref) {
  final fetchStories =
      ref.watch(chapterRepositoryProvider).getChaptersByStoryId;
  final createChapter = ref.watch(chapterRepositoryProvider).createChapter;

  return ChapterNotifier(
      fetchChapter: fetchStories, createChapter: createChapter);
});

class ChapterNotifier extends StateNotifier<List<Chapter>> {
  final Future<List<Chapter>> Function(int storyId) fetchChapter;
  final Future<Chapter> Function(ChapterForm) createChapter;

  ChapterNotifier({required this.fetchChapter, required this.createChapter})
      : super([]);

  Future<void> loadChapter(int storyId) async {
    try {
      final List<Chapter> chapters =
          await fetchChapter(storyId); // Obtén los capítulos por `storyId`
      state = chapters; // Actualiza el estado con los capítulos obtenidos
    } catch (e) {
      // Manejo de errores
      state = [];
    }
  }

  Future<void> addChapter(ChapterForm chapter) async {
    try {
      final Chapter newChapter =
          await createChapter(chapter); // Crea el nuevo capítulo
      state = [
        ...state,
        newChapter
      ]; // Actualiza el estado con el nuevo capítulo
    } catch (e) {
      // Manejo de errores al crear el capítulo
      print('Error al crear el capítulo: $e');
    }
  }
}
