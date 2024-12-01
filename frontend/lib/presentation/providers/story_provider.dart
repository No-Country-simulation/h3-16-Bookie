import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/datasources/storydb_datasource.dart';
import 'package:bookie/infrastructure/repositories/story_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyRepositoryProvider = Provider((ref) {
  return StoriesRepositoryImpl(StoriesDbDatasource());
});

final getStoriesProvider =
    StateNotifierProvider<StoriesNotifier, List<Story>>((ref) {
  final fetchStories = ref.watch(storyRepositoryProvider).getStories;

  return StoriesNotifier(fetchStories: fetchStories);
});

typedef StoryCallback = Future<List<Story>> Function();

class StoriesNotifier extends StateNotifier<List<Story>> {
  final StoryCallback fetchStories;

  StoriesNotifier({required this.fetchStories}) : super([]);

  Future<void> loadStories() async {
    final List<Story> stories =
        await fetchStories(); // Obtén las historias completas o las necesarias
    state = stories; // Actualiza el estado directamente con las historias
  }
}

// story por id
final getStoryByIdProvider =
    FutureProvider.family<Story, int>((ref, storyId) async {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getStory(storyId);
});

// historias de un usuario
final getStoriesByUserProvider =
    FutureProvider.family<List<Story>, int>((ref, userId) async {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getStoriesByUser(userId);
});

// crear historia
final createStoryProvider =
    FutureProvider.autoDispose.family<Story, StoryForm>((ref, storyForm) async {
  // print("Datos de la historia a crear: ${storyForm.toJson()}");

  final repository =
      ref.watch(storyRepositoryProvider); // Obtener el repositorio
  return await repository
      .createStory(storyForm); // Llamar al método de crear historia
});

// eliminar historia
final deleteStoryProvider =
    FutureProvider.autoDispose.family<void, int>((ref, storyId) async {
  final repository = ref.watch(storyRepositoryProvider);
  return await repository.deleteStory(storyId);
});
