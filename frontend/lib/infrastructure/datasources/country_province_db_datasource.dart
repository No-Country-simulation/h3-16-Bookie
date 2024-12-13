import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/domain/datasources/country_province_datasource.dart';
import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/infrastructure/mappers/country_mapper.dart';
import 'package:bookie/infrastructure/models/country_province_db.dart';

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
}
