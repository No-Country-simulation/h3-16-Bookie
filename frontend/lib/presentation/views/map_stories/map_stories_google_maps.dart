import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapStoriesGoogleMaps extends StatefulWidget {
  const MapStoriesGoogleMaps({super.key});

  @override
  State<MapStoriesGoogleMaps> createState() => _MapStoriesGoogleMapsState();
}

class _MapStoriesGoogleMapsState extends State<MapStoriesGoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer();

  // Posición inicial de la cámara
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Coordenadas de San Francisco
    zoom: 14.0,
  );

  // Posición con efecto 3D
  static const CameraPosition _position3D = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 18.0, // Aumenta el zoom para un mejor efecto 3D
    tilt: 60.0, // Inclinación de la cámara para el efecto 3D
    bearing: 180.0, // Rotación para ajustar el ángulo
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps 3D Mode")),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _enable3DView,
        label: const Text('Habilitar 3D'),
        icon: const Icon(Icons.threed_rotation),
      ),
    );
  }

  Future<void> _enable3DView() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position3D));
  }
}
