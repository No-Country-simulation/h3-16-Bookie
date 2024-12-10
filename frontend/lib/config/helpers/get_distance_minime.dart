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

    // final origin = "${currentPosition.latitude},${currentPosition.longitude}";

    // // Convertir las coordenadas a formato de texto para la URL
    // final destination = "$destinationLatitude,$destinationLongitude";

    // // Llamar a la API de Google Maps Distance Matrix
    // final url =
    //     "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&mode=walking&key=${Environment.theGoogleMapsApiKey}";

    // final response = await Dio().get(url);

    // // Verificar que la respuesta contiene los datos correctamente
    // final rows = response.data['rows'][0]['elements'];
    // final distance = rows[0]['distance']['value'] as int;

    // final distanceFinal = distance;

    // TODO REVISAR SI SE TENDRÍA EL GEOLOCATOR O SI SE TENDRÍA QUE SE USAN LOS DATOS DE LA API GOOGLE MAPS
    // Si ocurre un error, podemos usar la distancia del geolocator (comentado)
    final distance = distanceFromGeolocator(
      currentPosition,
      destinationLatitude,
      destinationLongitude,
    ).toInt();

    // if (distance - distanceFromGeolocator > 100) {
    // distanceFinal = distanceFromGeolocator;
    // } else {
    // distanceFinal = distance;
    // }

    // return distanceFromGeolocator; // Esto sería la alternativa con geolocator
    return distance;
  } catch (e) {
    print("Error al obtener la distancia: $e");

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
    print("Error al obtener la distancia: $e");
    return "10 m";
  }
}
