import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:dio/dio.dart';

Future<String> detectLanguage() async {
  try {
    // Obtener la posición actual
    final position = await determinePosition();

    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Environment.theGoogleMapsApiKey}";

    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      final addressComponents =
          response.data['results'][0]['address_components'] as List;

      final country = addressComponents
          .firstWhere((c) => c['types'].contains('country'))['short_name'];

      // Retorna el idioma basado en el país.
      if (country == "ES") {
        return "es";
      } else if (country == "US") {
        return "en";
      } else if (country == "BR") {
        return "pt";
      }
      return "es";
    }

    throw Exception("Error al obtener idioma por geolocalización");
  } catch (e) {
    print("Error al obtener idioma por geolocalización: $e");
    return "es";
  }
}