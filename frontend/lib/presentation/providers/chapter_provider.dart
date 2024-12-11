import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/infrastructure/datasources/chapterdb_datasource.dart';
import 'package:bookie/infrastructure/repositories/chapter_repository.dart';
import 'package:bookie/presentation/providers/stories_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chapterRepositoryProvider = Provider((ref) {
  return ChapterRepositoryImpl(ChapterDbDatasource());
});

final chapterProvider =
    StateNotifierProvider<ChapterNotifier, List<Chapter>>((ref) {
  final fetchStories =
      ref.watch(chapterRepositoryProvider).getChaptersByStoryId;
  final createChapter = ref.watch(chapterRepositoryProvider).createChapter;
  final editChapter = ref.watch(chapterRepositoryProvider).editChapter;

  return ChapterNotifier(
      fetchChapter: fetchStories,
      createChapter: createChapter,
      modChapter: editChapter,
      ref: ref);
});

class ChapterNotifier extends StateNotifier<List<Chapter>> {
  final Future<List<Chapter>> Function(int storyId) fetchChapter;
  final Future<Chapter> Function(ChapterForm) createChapter;
  final Future<Chapter> Function(ChapterForm, int chapterId) modChapter;

  // Agregamos una referencia a StoriesAllNotifier y StoriesUserNotifier
  final Ref ref;

  ChapterNotifier({
    required this.fetchChapter,
    required this.createChapter,
    required this.modChapter,
    required this.ref,
  }) : super([]);

  Future<void> getChapters(int storyId) async {
    try {
      final List<Chapter> chapters =
          await fetchChapter(storyId); // Obtén los capítulos por `storyId`

      // ordenaos por orden ascendente
      final sortedChapters = chapters.toList()
        ..sort((a, b) => a.id.compareTo(b.id));

      state = sortedChapters; // Actualiza el estado con los capítulos obtenidos
    } catch (e) {
      // Manejo de errores
      state = [];
    }
  }

  Future<Chapter> addChapter(ChapterForm chapter) async {
    try {
      final Chapter newChapter =
          await createChapter(chapter); // Crea el nuevo capítulo
      state = [
        ...state,
        newChapter
      ]; // Actualiza el estado con el nuevo capítulo

      // Actualizamos el estado de la historia del usuario
      ref.read(storiesUserProvider.notifier).updateStory(newChapter);

      return newChapter;
    } catch (e) {
      // Manejo de errores al crear el capítulo
      throw Exception('Error al crear el capítulo');
    }
  }

  Future<Chapter> editChapter(ChapterForm chapter, int chapterId) async {
    try {
      final Chapter newChapter =
          await modChapter(chapter, chapterId); // Edita el capítulo
      state = [
        ...state.where((chapter) => chapter.id != chapterId),
        newChapter
      ]; // Actualiza el estado con el nuevo capítulo

      // // Actualizamos el estado de la historia del usuario
      // ref.read(storiesUserProvider.notifier).updateStory(newChapter);

      return newChapter;
    } catch (e) {
      // Manejo de errores al editar el capítulo
      throw Exception('Error al editar el capítulo');
    }
  }

  int currentChapter(int chapterId) {
    return state.indexWhere((chapter) => chapter.id == chapterId);
  }

  void resetChapters() {
    state = [];
  }
}
