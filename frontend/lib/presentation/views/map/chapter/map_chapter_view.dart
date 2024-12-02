import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapChapterView extends StatefulWidget {
  // final int storyId;
  static const String name = 'map-chapter-view';
  final double latitude;
  final double longitude;

  const MapChapterView(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<MapChapterView> createState() => _MapChapterViewState();
}

class _MapChapterViewState extends State<MapChapterView> {
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = {};

  void customMarker() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_story_noread.webp')
        .then(
      (value) {
        customIcon = value;
      },
    );
  }

  void addMarker() async {
    customMarker();
    Marker marker = Marker(
      markerId: const MarkerId('custom_marker'),
      position: LatLng(widget.latitude, widget.longitude),
      icon: customIcon,
      infoWindow: const InfoWindow(
        title: 'Marcador Personalizado',
        snippet: 'Este es un marcador con un ícono cargado dinámicamente.',
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  void initState() {
    super.initState();
    customMarker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 17,
              tilt: 60,
              bearing: 0,
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
                // draggable: true,
                // onDragEnd: (value) {
                //   // Actualiza la ubicación seleccionada
                //   print('DragEnd: ${value.latitude}, ${value.longitude}');
                // },
                infoWindow: InfoWindow(
                  title: 'Seleccionado',
                  snippet: 'Ubicación de la historia',
                ),
              ),
            },
            zoomControlsEnabled: true, // Activa los botones de zoom
            myLocationButtonEnabled: true, // Activa el botón de ubicación
            mapToolbarEnabled:
                true, // Habilita la barra de herramientas de Google Maps
            myLocationEnabled:
                true, // Muestra la ubicación actual (requiere permisos)
          ),
        ],
      ),
    );
  }
}
