import 'package:bookie/domain/datasources/country_province_datasource.dart';
import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/domain/repositories/country_province_repository.dart';

class CountryProvinceDbRepositoryImpl implements CountryProvinceRepository {
  final CountryProvinceDatasource datasource;

  CountryProvinceDbRepositoryImpl(this.datasource);

  @override
  Future<List<CountryProvince>> getCountryProvince() {
    return datasource.getCountryProvince();
  }

  @override
  Future<List<Story>> getStoriesByCountryName(String countryName) {
    return datasource.getStoriesByCountryName(countryName);
  }

  @override
  Future<List<Story>> getStoriesByProvinceName(String provinceName) {
    return datasource.getStoriesByProvinceName(provinceName);
  }
}
