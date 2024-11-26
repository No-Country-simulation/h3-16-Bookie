import 'package:bookie/domain/entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
}
