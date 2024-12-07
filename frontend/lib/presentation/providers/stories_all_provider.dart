import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/datasources/storydb_datasource.dart';
import 'package:bookie/infrastructure/repositories/story_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyRepositoryProvider = Provider((ref) {
  return StoriesRepositoryImpl(StoriesDbDatasource());
});

// story por id
final getStoryByIdProvider =
    FutureProvider.family<Story, int>((ref, storyId) async {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getStory(storyId);
});

// final getStoryByIdProvider2 =
//     FutureProvider.family<Story, int>((ref, storyId) async {
//   final repository = ref.watch(storiesAllProvider);
//   return repository.getStory(storyId);
// });

// stories de un usuario
final getStoriesByUserProvider =
    FutureProvider.family<List<Story>, int>((ref, userId) async {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getStoriesByUser(userId);
});

// estado global de las stories
final storiesAllProvider =
    StateNotifierProvider<StoriesAllNotifier, List<Story>>((ref) {
  final repository = ref.watch(storyRepositoryProvider);

  return StoriesAllNotifier(
    getStoriesAllNotifier: repository.getStories,
    getStoryByIdNotifier: repository.getStory,
  );
});

class StoriesAllNotifier extends StateNotifier<List<Story>> {
  final Future<List<Story>> Function() getStoriesAllNotifier;
  final Future<Story> Function(int storyId) getStoryByIdNotifier;

  StoriesAllNotifier({
    required this.getStoriesAllNotifier,
    required this.getStoryByIdNotifier,
  }) : super([]);

  Future<void> loadAllStories() async {
    final List<Story> stories = await getStoriesAllNotifier();

    // TODO: REVISAR SI SE TENDRÍA QUE ORDENAR POR DISTANCIA DEL SUSUARIO
    state = stories.where((story) => story.chapters.isNotEmpty).toList();
  }

  void addStory(Story story) {
    // TODO CUANDO SE AÑADE NO TE OLVIDES DE ORDENAR POR DISTANCIA DEL SUSUARIO REVISAR DE ULTIMAS.
    state = [...state, story];
  }

  void removeStory(int storyId) {
    state = state.where((story) => story.id != storyId).toList();
  }

  Future<Story> getStoryById(int storyId) {
    return getStoryByIdNotifier(storyId);
  }
}



// crear historia
// final createStoryProvider =
//     FutureProvider.autoDispose.family<Story, StoryForm>((ref, storyForm) async {
//   // print("Datos de la historia a crear: ${storyForm.toJson()}");

//   final repository =
//       ref.watch(storyRepositoryProvider); // Obtener el repositorio
//   return await repository
//       .createStory(storyForm); // Llamar al método de crear historia
// });

// // eliminar historia
// final deleteStoryProvider =
//     FutureProvider.autoDispose.family<void, int>((ref, storyId) async {
//   final repository = ref.watch(storyRepositoryProvider);
//   return await repository.deleteStory(storyId);
// });
