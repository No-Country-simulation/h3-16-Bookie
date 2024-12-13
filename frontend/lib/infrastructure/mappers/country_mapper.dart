import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/infrastructure/models/country_province_db.dart';

class CountryMapper {
  static CountryProvince toCountryProvince(CountryProvinceDb countryDb) {
    return CountryProvince(
      id: countryDb.id,
      name: countryDb.name,
      provinces: countryDb.provinces
          .map((provinceDb) => toProvince(provinceDb))
          .toList(),
    );
  }

  static Province toProvince(ProvinceDb provinceDb) {
    return Province(
      id: provinceDb.id,
      name: provinceDb.name,
    );
  }
}
