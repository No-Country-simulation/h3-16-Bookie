import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:dio/dio.dart';

Future<List<Map<String, dynamic>>> getSortedStoriesFromGoogleMaps(
    List<Map<String, dynamic>> unreadStories) async {
  // Obtener la posición actual
  final currentPosition = await determinePosition();
  final origin = "${currentPosition.latitude},${currentPosition.longitude}";

  // Crear las coordenadas de destino
  final destinations = unreadStories
      .map((story) => "${story['latitud']},${story['longitud']}")
      .join('|');

  // Llamar a la API de Google Maps Distance Matrix
  final url =
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destinations&mode=walking&key=${Environment.theGoogleMapsApiKey}";

  final response = await Dio().get(url);

  if (response.statusCode != 200) {
    throw Exception("Error al llamar a la API de Google Maps");
  }

  // Procesar la respuesta de la API
  final rows = response.data['rows'][0]['elements'];

  final enrichedStories = unreadStories.asMap().entries.map((entry) {
    final index = entry.key;
    final story = entry.value;
    final element = rows[index];
    final distance = element['distance']['value'];
    final distanceInKm =
        (distance / 1000).toStringAsFixed(1); // Convertir metros a km
    final distanceInMeters =
        distance.toStringAsFixed(0); // Convertir metros a m

    return {
      ...story,
      'distance':
          "a ${distance <= 500 ? "${distanceInMeters}m" : "${distanceInKm}km"}",
      'distanceInMeters': distance,
    };
  }).toList();

  // Ordenar por distancia en metros
  enrichedStories.sort((a, b) {
    return a['distanceInMeters'].compareTo(b['distanceInMeters']);
  });

  return enrichedStories;
}
