import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoryViewMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const StoryViewMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StoryViewMap> createState() => _StoryViewMapState();
}

class _StoryViewMapState extends State<StoryViewMap> {
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = {};

  void customMarker() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_story.webp')
        .then(
      (value) {
        customIcon = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    customMarker();
  }

  @override
  Widget build(BuildContext context) {
    // Icono del marcador

    void addMarker() {
      // Crear un marcador con el ícono personalizado
      Marker marker = Marker(
        markerId: const MarkerId('custom_marker'),
        position: const LatLng(0, 0),
        icon: customIcon, // Usar el ícono personalizado
        infoWindow: const InfoWindow(
          title: 'Marcador Personalizado',
          snippet: 'Este es un marcador con un ícono cargado dinámicamente.',
        ),
      );

      setState(() {
        _markers.add(marker); // Actualizar la lista de marcadores
      });
    }

    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 17,
              // tilt: 60,
              // bearing: 180,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              addMarker(); // Agregar marcador cuando el mapa se cree
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: LatLng(widget.latitude, widget.longitude),
                icon: customIcon,
                infoWindow: InfoWindow(
                  title: 'Seleccionado',
                  snippet: 'Ubicación de la historia',
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
