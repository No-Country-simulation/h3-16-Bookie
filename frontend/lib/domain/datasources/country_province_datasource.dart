import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';

abstract class CountryProvinceDatasource {
  Future<List<CountryProvince>> getCountryProvince();

  Future<List<Story>> getStoriesByCountryName(String countryName);

  Future<List<Story>> getStoriesByProvinceName(String provinceName);
}
