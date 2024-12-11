import 'package:bookie/domain/entities/story_entity.dart';

abstract class StoriesDatasource {
  Future<List<Story>> getStories();

  Future<List<Story>> getStoriesByUser(int userId);

  Future<Story> getStory(int storyId);

  Future<Story> createStory(StoryForm storyForm);

  Future<void> deleteStory(int storyId);
}
