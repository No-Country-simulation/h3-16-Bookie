import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/datasources/storydb_datasource.dart';
import 'package:bookie/infrastructure/repositories/story_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storyRepositoryProvider = Provider((ref) {
  return StoryRepositoryImpl(StoryDbDatasource());
});

final getStoriesProvider =
    StateNotifierProvider<StoriesNotifier, List<Story>>((ref) {
  final fetchMoreStories = ref.watch(storyRepositoryProvider).getStories;

  return StoriesNotifier(fetchMoreStories: fetchMoreStories);
});

typedef MovieCallback = Future<List<Story>> Function({int page});

class StoriesNotifier extends StateNotifier<List<Story>> {
  int currentPage = 0;
  MovieCallback fetchMoreStories;

  StoriesNotifier({
    required this.fetchMoreStories,
  }) : super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Story> movies = await fetchMoreStories(page: currentPage);
    state = [...state, ...movies];
  }
}
