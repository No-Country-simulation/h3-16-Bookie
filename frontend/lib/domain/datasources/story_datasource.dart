import 'package:bookie/domain/entities/story.dart';

abstract class StoriesDatasource {
  Future<List<Story>> getStories();

  Future<List<Story>> getStoriesByUser(int userId);

  Future<Story> getStory(int storyId);

  Future<Story> createStory(StoryForm storyForm);
}
