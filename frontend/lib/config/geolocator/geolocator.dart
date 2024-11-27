import 'package:bookie/domain/entities/story.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Verifica si los servicios de ubicación están habilitados
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Servicios de ubicación deshabilitados.');
  }

  // Verifica permisos
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Permisos de ubicación denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Permisos de ubicación denegados permanentemente. Actualízalos en configuración.');
  }

  // Devuelve la posición actual
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      // accuracy: LocationAccuracy.bestForNavigation,
      accuracy: LocationAccuracy.high,
      distanceFilter: 50, // Actualiza cada 100 metros
    ),
  );
}

double distanceFromGeolocator(
  Position currentPosition,
  Story story,
) {
  final distance = Geolocator.distanceBetween(
    currentPosition.latitude,
    currentPosition.longitude,
    story.chapters![0].latitude,
    story.chapters![0].longitude,
  );

  return distance;
}
