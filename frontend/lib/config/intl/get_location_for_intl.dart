import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/get_language_for_country.dart';
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
      return getLanguageForCountry(country);
    }

    throw Exception("Error al obtener idioma por geolocalización");
  } catch (e) {
    return "en";
  }
}
