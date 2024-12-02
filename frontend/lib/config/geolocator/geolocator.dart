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
  double latitude,
  double longitude,
) {
  final distance = Geolocator.distanceBetween(
    currentPosition.latitude,
    currentPosition.longitude,
    latitude,
    longitude,
  );

  return distance;
}

bool isWithinRadius(
    Position userPosition, double targetLat, double targetLon, double radius) {
  final distance = distanceFromGeolocator(
    userPosition,
    targetLat,
    targetLon,
  );

  return distance <= radius;
}
