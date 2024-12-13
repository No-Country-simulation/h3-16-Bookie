import 'package:bookie/domain/entities/country_province_entity.dart';

abstract class CountryProvinceRepository {
  Future<List<CountryProvince>> getCountryProvince();
}
