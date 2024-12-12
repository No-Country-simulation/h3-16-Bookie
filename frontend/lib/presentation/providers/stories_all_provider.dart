import 'package:bookie/config/helpers/sorted.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/datasources/storydb_datasource.dart';
import 'package:bookie/infrastructure/repositories/story_repository.dart';
import 'package:bookie/presentation/providers/location_provider.dart';
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
    ref: ref,
  );
});

class StoriesAllNotifier extends StateNotifier<List<Story>> {
  final Future<List<Story>> Function() getStoriesAllNotifier;
  final Future<Story> Function(int storyId) getStoryByIdNotifier;
  final Ref ref;

  StoriesAllNotifier({
    required this.getStoriesAllNotifier,
    required this.getStoryByIdNotifier,
    required this.ref,
  }) : super([]);

  Future<void> loadAllStories() async {
    final List<Story> stories = await getStoriesAllNotifier();

    final storiesWithoutEmptyChapters =
        stories.where((story) => story.chapters.isNotEmpty).toList();

    final sortedStories = await getSortedStories(storiesWithoutEmptyChapters);

    ref.read(locationProvider.notifier).updateLocation(
        sortedStories.currentPosition.latitude,
        sortedStories.currentPosition.longitude);

    state = sortedStories.stories;
  }

  void addStory(Story story) {
    state = [...state, story];
  }

  void removeStory(int storyId) {
    state = state.where((story) => story.id != storyId).toList();
  }

  Future<Story> getStoryById(int storyId) {
    return getStoryByIdNotifier(storyId);
  }
}
