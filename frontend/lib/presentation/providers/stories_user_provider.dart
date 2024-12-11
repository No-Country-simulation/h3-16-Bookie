import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoriesUserState {
  final List<Story> stories;
  final bool isLoading;
  final bool hasError;
  final bool hasLoaded;

  StoriesUserState({
    this.stories = const [],
    this.isLoading = false,
    this.hasError = false,
    this.hasLoaded = false,
  });

  StoriesUserState copyWith({
    List<Story>? stories,
    bool? isLoading,
    bool? hasError,
    bool? hasLoaded,
  }) {
    return StoriesUserState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }
}

// estado global de las stories
final storiesUserProvider =
    StateNotifierProvider<StoriesUserNotifier, StoriesUserState>((ref) {
  final repository = ref.watch(storyRepositoryProvider);

  return StoriesUserNotifier(
      getStoriesUserNotifier: repository.getStoriesByUser,
      createStoryNotifier: repository.createStory,
      deleteStoryNotifier: repository.deleteStory,
      ref: ref);
});

class StoriesUserNotifier extends StateNotifier<StoriesUserState> {
  final Future<List<Story>> Function(int userId) getStoriesUserNotifier;
  final Future<Story> Function(StoryForm storyForm) createStoryNotifier;
  final Future<void> Function(int storyId) deleteStoryNotifier;

  // Agregamos una referencia a StoriesAllNotifier
  final Ref ref;

  StoriesUserNotifier({
    required this.getStoriesUserNotifier,
    required this.createStoryNotifier,
    required this.deleteStoryNotifier,
    required this.ref,
  }) : super(StoriesUserState());

  Future<void> loadUserStories() async {
    try {
      if (state.hasLoaded) {
        return; // No hacer nada si ya se cargaron las historias
      }

      state = state.copyWith(isLoading: true);
      final userId = await SharedPreferencesKeys.getCredentials()
          .then((value) => int.parse(value.id ?? '0'));
      final List<Story> stories = await getStoriesUserNotifier(userId);

      // Ordena las historias por id de manera descendente
      final updatedStories = List<Story>.from(stories)
        ..sort((a, b) => b.id.compareTo(a.id)); // Ordena de mayor a menor ID

      state = state.copyWith(
          stories: updatedStories, isLoading: false, hasLoaded: true);
    } catch (e) {
      state = state.copyWith(hasError: true);
    }
  }

  // actualizamos la historia del userStories y del allStories
  Future<void> updateStory(Chapter newChapter) async {
    try {
      state = state.copyWith(isLoading: true);

      // Actualizamos las historias de manera inmutable
      final updatedStoriesUser = state.stories.map((story) {
        if (story.id == newChapter.historyId) {
          // Creamos una nueva instancia de Story con la lista de capítulos actualizada
          return story.copyWith(
            chapters: [
              ...story.chapters,
              newChapter
            ], // Añadimos el nuevo capítulo
          );
        }
        return story; // Devolvemos la historia sin cambios si no coincide el ID
      }).toList();

      // Actualizamos el estado con las historias modificadas
      state = state.copyWith(stories: updatedStoriesUser, isLoading: false);

      // Actualizamos las historias del allStories
      // ref.read(storiesAllProvider.notifier).updateStory(newChapter);
    } catch (e) {
      state = state.copyWith(hasError: true, isLoading: false);
      rethrow;
    }
  }

  // no actualizar las storiesAll porque recien se crea, pero cuando añades un capitulo recien actualizas esta historia añadiendo al userStories y al allStories
  Future<Story> createStory(StoryForm storyForm) async {
    try {
      state = state.copyWith(isLoading: true);
      final Story story = await createStoryNotifier(storyForm);

      state =
          state.copyWith(stories: [story, ...state.stories], isLoading: false);

      return story;
    } catch (e) {
      state = state.copyWith(hasError: true);
      rethrow;
    }
  }

  Future<void> deleteStory(int storyId) async {
    try {
      state = state.copyWith(isLoading: true);
      await deleteStoryNotifier(storyId);
      // Actualizamos el estado global también
      ref.read(storiesAllProvider.notifier).removeStory(storyId);

      state = state.copyWith(
        stories: state.stories.where((story) => story.id != storyId).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(hasError: true);
      rethrow;
    }
  }

  // Método para limpiar el estado de las historias al cerrar sesión
  void clearStoriesOnLogout() {
    state = StoriesUserState(); // Reinicia el estado a su valor inicial
  }
}
