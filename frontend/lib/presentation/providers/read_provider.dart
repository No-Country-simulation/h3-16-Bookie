import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/entities/read_entity.dart';
import 'package:bookie/infrastructure/datasources/readdb_datasource.dart';
import 'package:bookie/infrastructure/repositories/read_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final readRepositoryProvider = Provider((ref) {
  return ReadRepositoryImpl(ReadDbDatasource());
});

final readProvider = StateNotifierProvider<ReadNotifier, List<Read>>((ref) {
  final repository = ref.watch(readRepositoryProvider);

  return ReadNotifier(
    getReadNotifier: repository.getReaders,
    addReaderNotifier: repository.addReader,
    addReaderChapterNotifier: repository.addReaderChapter,
    completeReaderChapterNotifier: repository.completeReaderChapter,
  );
});

class ReadNotifier extends StateNotifier<List<Read>> {
  final Future<List<Read>> Function() getReadNotifier;
  final Future<int> Function(ReadForm readForm) addReaderNotifier;
  final Future<int> Function(ReadChapterForm readChapterForm)
      addReaderChapterNotifier;
  final Future<void> Function(int readerId) completeReaderChapterNotifier;

  ReadNotifier(
      {required this.getReadNotifier,
      required this.addReaderNotifier,
      required this.addReaderChapterNotifier,
      required this.completeReaderChapterNotifier})
      : super([]);

  // Método para obtener todos los favoritos
  Future<List<Read>> getReaders() async {
    try {
      final List<Read> readers = await getReadNotifier();

      state = readers; // Actualiza el estado con los favoritos obtenidos
      return readers;
    } catch (e) {
      return [];
    }
  }

  // Método para limpiar el estado de las historias al cerrar sesión
  void clearReadersOnLogout() {
    state = []; // Reinicia el estado a su valor inicial
  }

  Future<int> addReader(int storyId) async {
    try {
      final userId = await SharedPreferencesKeys.getCredentials()
          .then((value) => int.parse(value.id ?? '0'));

      final reader = ReadForm(
        userId: userId,
        historyId: storyId,
      );

      final readerId = await addReaderNotifier(reader);

      return readerId;
      // state = [...state, favorite];

      // await getReaders();
    } catch (e) {
      throw Exception("No se puede agregar el favorito");
    }
  }

  Future<int> addReaderChapter(int storyId, int chapterId, int readerId) async {
    try {
      final formReaderChapter = ReadChapterForm(
        chapterId: chapterId,
        readerId: readerId,
      );

      final readerChapterId = await addReaderChapterNotifier(formReaderChapter);

      return readerChapterId;
    } catch (e) {
      throw Exception("No se puede eliminar el favorito");
    }
  }

  Future<void> completeReaderChapter(int storyId, int chapterId) async {
    try {
      int? readerId;
      int? readerChapterId;

      final readerFind =
          state.firstWhere((element) => element.story.id == storyId,
              orElse: () => Read(
                    id: -1,
                    story: ReadStory(
                      id: storyId,
                      title: '',
                      completeStory: false,
                      chapters: [],
                    ),
                    readChapters: [],
                  ));

      if (readerFind.id != -1) {
        readerId = readerFind.id;

        final readerChapterFindComplete = readerFind.readChapters.firstWhere(
            (element) {
          return element.readChapter.id == chapterId && element.completeChapter;
        },
            orElse: () => ReadChapterComplete(
                readChapter: ReadChapter(id: -1, title: '', image: ""),
                completeChapter: false));

        if (readerChapterFindComplete.readChapter.id != -1) {
          return;
        } else {
          readerChapterId =
              await addReaderChapter(storyId, chapterId, readerId);

          await completeReaderChapterNotifier(readerChapterId);
          await getReaders();

          return;
        }
      } else {
        readerId = await addReader(storyId);
      }

      readerChapterId = await addReaderChapter(storyId, chapterId, readerId);
      await completeReaderChapterNotifier(readerChapterId);

      await getReaders();

      return;
    } catch (e) {
      throw Exception("Error al completar el capítulo del lector");
    }
  }
}
