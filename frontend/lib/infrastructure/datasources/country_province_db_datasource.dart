import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/domain/datasources/country_province_datasource.dart';
import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/country_mapper.dart';
import 'package:bookie/infrastructure/mappers/storydb_mapper.dart';
import 'package:bookie/infrastructure/models/country_province_db.dart';
import 'package:bookie/infrastructure/models/story_db.dart';

class CountryProvinceDbDatasource extends CountryProvinceDatasource {
  @override
  Future<List<CountryProvince>> getCountryProvince() async {
    try {
      final response = await FetchApi.fetchDio().get('/v1/countries');

      final countriesResponse = CountryProvinceDb.fromJsonList(response.data);

      final countries = countriesResponse.map((countryDb) {
        return CountryMapper.toCountryProvince(countryDb);
      }).toList();

      return countries;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Story>> getStoriesByCountryName(String countryName) async {
    try {
      final response = await FetchApi.fetchDio().get(
        '/v1/history/by-country?country=$countryName',
      );

      final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

      final List<Story> stories =
          storiesDBResponse.map(StoryMapper.storyDbToEntity).toList();

      // filtrar stories que solo tengan capítulos
      stories.removeWhere((story) => story.chapters.isEmpty);

      return stories;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Story>> getStoriesByProvinceName(String provinceName) async {
    try {
      final response = await FetchApi.fetchDio().get(
        '/v1/history/by-province?province=$provinceName',
      );

      final storiesDBResponse = StoryDbResponse.fromJsonList(response.data);

      final List<Story> stories =
          storiesDBResponse.map(StoryMapper.storyDbToEntity).toList();

      // filtrar stories que solo tengan capítulos
      stories.removeWhere((story) => story.chapters.isEmpty);

      return stories;
    } catch (e) {
      rethrow;
    }
  }
}
