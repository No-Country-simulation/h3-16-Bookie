import 'package:bookie/domain/entities/country_province_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
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
        .where((countryProvince) =>
            countryProvince.name != "TEMPORAL") // Filtrar elementos
        .map((countryProvince) => Country(
              id: countryProvince.id,
              name: countryProvince.name,
            ))
        .toList();
  }

  List<Province> getProvinces() {
    return state
        .expand((countryProvince) => countryProvince.provinces)
        .map((province) => Province(
              id: province.id,
              name: province.name == "TEMPORAL" ? "OTROS" : province.name,
            ))
        .toList()
      ..sort((a, b) {
        // Mover "OTROS" al final
        if (a.name == "OTROS" && b.name != "OTROS") return 1;
        if (a.name != "OTROS" && b.name == "OTROS") return -1;
        return 0;
      });
  }
}

final getStoriesByCountryNameProvider =
    FutureProvider.family.autoDispose<List<Story>, String>((ref, countryName) async {
  final repository = ref.watch(countryProvinceRepositoryProvider);
  return repository.getStoriesByCountryName(countryName);
});

final getStoriesByProvinceNameProvider =
    FutureProvider.family.autoDispose<List<Story>, String>((ref, provinceName) async {
  final repository = ref.watch(countryProvinceRepositoryProvider);
  return repository.getStoriesByProvinceName(provinceName);
});


// Estado para manejar el proveedor actual seleccionado
final filterCountryOrProvinceProvider =
    StateNotifierProvider<FilterStateNotifier, FilterCountryOrProvinceState>((ref) => FilterStateNotifier());

class FilterStateNotifier extends StateNotifier<FilterCountryOrProvinceState> {
  FilterStateNotifier() : super(FilterCountryOrProvinceState(null));

  void selectProvider(ProviderBase<AsyncValue<List<Story>>>? provider) {
    state = FilterCountryOrProvinceState(provider);
  }
}

class FilterCountryOrProvinceState {
  final ProviderBase<AsyncValue<List<Story>>>? provider;

  FilterCountryOrProvinceState(this.provider);
}