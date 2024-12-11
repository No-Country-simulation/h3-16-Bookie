import 'package:geocoding/geocoding.dart';

class GetCountryAndProvince {
  final String country;
  final String province;
  final String address1;
  final String address2;

  GetCountryAndProvince({
    required this.country,
    required this.province,
    required this.address1,
    required this.address2,
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
      final address1 = placemark.thoroughfare;
      final address2 = placemark.subThoroughfare;

      if (country != null &&
          province != null &&
          address1 != null &&
          address2 != null) {
        return GetCountryAndProvince(
            country: country,
            province: province,
            address1: address1,
            address2: address2);
      }
    }
  } catch (e) {
    print('Error using geocoding: $e');
  }
  return null; // En caso de error o datos incompletos
}
