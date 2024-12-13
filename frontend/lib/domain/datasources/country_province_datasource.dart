import 'package:bookie/domain/entities/country_province_entity.dart';

abstract class CountryProvinceDatasource {
  Future<List<CountryProvince>> getCountryProvince();
}
