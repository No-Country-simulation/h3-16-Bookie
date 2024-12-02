import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:dio/dio.dart';

Future<List<Story>> getSortedStories(List<Story> stories) async {
  try {
    // Obtener la posición actual
    final currentPosition = await determinePosition();

    final origin = "${currentPosition.latitude},${currentPosition.longitude}";

    final distancesCalculateFromGeolocator = stories
        .map(
          (story) => distanceFromGeolocator(
            currentPosition,
            story.chapters![0].latitude,
            story.chapters![0].longitude,
          ),
        )
        .toList();

    // Crear las coordenadas de destino
    final destinations = stories
        .map((story) =>
            "${story.chapters![0].latitude},${story.chapters![0].longitude}")
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

    for (int i = 0; i < stories.length; i++) {
      final element = rows[i];
      final distance = element['distance']['value']; // En metros
      final distanceGeolocator = distancesCalculateFromGeolocator[i].toInt();

      stories[i].distance =
          distance - distanceGeolocator > 100 ? distanceGeolocator : distance;
    }

    stories.sort((a, b) => a.distance.compareTo(b.distance));

    return stories;
  } catch (e) {
    print("Error al obtener la posición: $e");
    return [];
  }
}
