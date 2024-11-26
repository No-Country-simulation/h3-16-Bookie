import 'package:bookie/domain/datasources/story_datasource.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryDatasource datasource;

  StoryRepositoryImpl(this.datasource);

  @override
  Future<List<Story>> getStories({int page = 1}) {
    return datasource.getStories(page: page);
  }
}
