import 'package:geocoding/geocoding.dart';

class GetCountryAndProvince {
  final String country;
  final String province;

  GetCountryAndProvince({
    required this.country,
    required this.province,
  });
}

Future<GetCountryAndProvince?> getCountryAndProvinceUsingGeocoding(
    double lat, double lng) async {
  try {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final country = placemark.country;
      final province = placemark.subAdministrativeArea;

      if (country != null && province != null) {
        return GetCountryAndProvince(country: country, province: province);
      }
    }
  } catch (e) {
    print('Error using geocoding: $e');
  }
  return null; // En caso de error o datos incompletos
}
