import 'package:bookie/config/helpers/get_country_province.dart';
import 'package:bookie/config/helpers/short_name.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<List<String>> getAddressesFromCoordinates(
    List<List<double>> coordinates) async {
  List<String> addresses = [];

  for (var coordinate in coordinates) {
    double lat = coordinate[0];
    double lng = coordinate[1];

    // Llamar a la función para obtener el país, provincia y dirección
    final result = await getCountryAndProvinceUsingGeocoding(lat, lng);

    if (result != null && result.address1 != "" && result.address2 != "") {
      // Si el resultado no es null, agregar la dirección al listado
      addresses.add(shortName3('${result.address1}, ${result.address2}'));
    } else {
      // Si no se pudo obtener la dirección, agregar un mensaje o dejarlo vacío
      addresses.add('Dirección no encontrada');
    }
  }

  return addresses;
}

Future<LatLng> latLongToAddress(String address) async {
  try {
    final location = await locationFromAddress(address);

    if (location.isNotEmpty) {
      return LatLng(location[0].latitude, location[0].longitude);
    } else {
      throw Exception('No se pudo obtener la ubicación');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error en la búsqueda de la ubicación con geocoding');
  }
}
