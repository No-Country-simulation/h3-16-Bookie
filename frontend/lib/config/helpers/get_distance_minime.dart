import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/format_distance.dart';
import 'package:bookie/config/helpers/get_country_province.dart';
import 'package:bookie/config/helpers/short_name.dart';

Future<int> getDistanceFromOriginToDestination(
  double destinationLatitude,
  double destinationLongitude,
) async {
  try {
    // Obtener la posición actual
    final currentPosition = await determinePosition();

    final distance = distanceFromGeolocator(
      currentPosition,
      destinationLatitude,
      destinationLongitude,
    ).toInt();

    return distance;
  } catch (e) {

    return 10; // En caso de error, devolvemos 0 o un valor adecuado
  }
}

// obtener label de ubicacion junto con la distancia
Future<String> getCountryAndProvinceAndDistance(
  double destinationLatitude,
  double destinationLongitude,
) async {
  try {
    final location = await getCountryAndProvinceUsingGeocoding(
      destinationLatitude,
      destinationLongitude,
    );

    String stringLocation = "";

    if (location == null) {
      stringLocation = "";
    }
    stringLocation =
        shortenName2("${location?.province}, ${location?.country}");

    // Obtener la distancia
    final distance = await getDistanceFromOriginToDestination(
      destinationLatitude,
      destinationLongitude,
    );

    final distanceString = formatDistanceOnly(distance);

    return "$stringLocation. $distanceString";
  } catch (e) {
    return "10 m";
  }
}
