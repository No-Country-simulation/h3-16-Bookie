import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/domain/datasources/story_datasource.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/mappers/storydb_mapper.dart';
import 'package:bookie/infrastructure/models/story_db.dart';
import 'package:dio/dio.dart';

class StoryDbDatasource extends StoryDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.theUrlDeployBackend,
  ));

  @override
  Future<List<Story>> getStories({int page = 1}) async {
    final response = await dio.get('/v1/history/all');
    final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

    final List<Story> stories = storiesDBResponse
        // .where((story) => story.campoafiltrar)
        .map((storydb) => StoryMapper.storyDBToEntity(storydb))
        .toList();

    return stories;
  }
}
