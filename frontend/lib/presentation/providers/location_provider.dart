import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier extends StateNotifier<LatLng> {
  LocationNotifier()
      : super(LatLng(0.0, 0.0)); // Inicializamos con latitud y longitud 0.0

  // Actualizar la ubicación
  void updateLocation(double latitude, double longitude) {
    state = LatLng(latitude, longitude);
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LatLng>(
  (ref) => LocationNotifier(),
);
