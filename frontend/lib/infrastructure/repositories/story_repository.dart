import 'package:bookie/domain/datasources/story_datasource.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/domain/repositories/story_repository.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesDatasource datasource;

  StoriesRepositoryImpl(this.datasource);

  @override
  Future<List<Story>> getStories() {
    return datasource.getStories();
  }

  @override
  Future<List<Story>> getStoriesByUser(int userId) {
    return datasource.getStoriesByUser(userId);
  }

  @override
  Future<Story> getStory(int storyId) {
    return datasource.getStory(storyId);
  }

  @override
  Future<Story> createStory(StoryForm storyForm) {
    return datasource.createStory(storyForm);
  }

  @override
  Future<void> deleteStory(int storyId) {
    return datasource.deleteStory(storyId);
  }
}
