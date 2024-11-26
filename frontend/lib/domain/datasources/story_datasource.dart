import 'package:bookie/domain/entities/story.dart';

abstract class StoryDatasource {
  Future<List<Story>> getStories();
}
