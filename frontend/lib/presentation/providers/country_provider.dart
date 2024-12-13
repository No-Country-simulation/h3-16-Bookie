import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/infrastructure/datasources/country_province_db_datasource.dart';
import 'package:bookie/infrastructure/repositories/country_province_db_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countryProvinceRepositoryProvider = Provider((ref) {
  return CountryProvinceDbRepositoryImpl(CountryProvinceDbDatasource());
});

final countryProvinceProvider =
    StateNotifierProvider<CountryProvinceNotifier, List<CountryProvince>>(
        (ref) {
  final countriesProvince =
      ref.watch(countryProvinceRepositoryProvider).getCountryProvince;

  return CountryProvinceNotifier(getCountriesProvince: countriesProvince);
});

typedef CountryProvinceCallback = Future<List<CountryProvince>> Function();

class CountryProvinceNotifier extends StateNotifier<List<CountryProvince>> {
  final CountryProvinceCallback getCountriesProvince;

  CountryProvinceNotifier({required this.getCountriesProvince}) : super([]);

  Future<void> loadCountriesProvinces() async {
    final List<CountryProvince> countriesProvinces =
        await getCountriesProvince(); // Obtén las historias completas o las necesarias
    state =
        countriesProvinces; // Actualiza el estado directamente con las historias
  }

  List<Country> getCountries() {
    return state
        .map((countryProvince) => Country(
              id: countryProvince.id,
              name: countryProvince.name,
            ))
        .toList();
  }

  List<Province> getProvinces() {
    return state
        .expand((countryProvince) => countryProvince.provinces)
        .map((province) => Province(id: province.id, name: province.name))
        .toList();
  }
}
