import 'package:bookie/domain/datasources/country_province_datasource.dart';
import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/domain/repositories/country_province_repository.dart';

class CountryProvinceDbRepositoryImpl implements CountryProvinceRepository {
  final CountryProvinceDatasource datasource;

  CountryProvinceDbRepositoryImpl(this.datasource);

  @override
  Future<List<CountryProvince>> getCountryProvince() {
    return datasource.getCountryProvince();
  }
}
