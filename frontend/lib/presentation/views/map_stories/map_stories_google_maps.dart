import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapStoriesGoogleMaps extends StatefulWidget {
  const MapStoriesGoogleMaps({super.key});

  @override
  State<MapStoriesGoogleMaps> createState() => _MapStoriesGoogleMapsState();
}

class _MapStoriesGoogleMapsState extends State<MapStoriesGoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _currentPosition =
      const LatLng(-8.110106, -79.025299); // Coordenadas iniciales
  final List<Marker> _markers = [];
  String _selectedPlace = ''; // Texto del lugar seleccionado

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addNearbyMarkers();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, habilita los servicios de ubicación.'),
      ));
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Los permisos de ubicación fueron denegados.'),
        ));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Los permisos de ubicación están denegados permanentemente.'),
      ));
      return;
    }

    // Obtener la ubicación actual
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Mi ubicación'),
        ),
      );
    });

    // Mover la cámara a la ubicación actual
    final controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14.0));
  }

  void _addNearbyMarkers() {
    const nearbyPlaces = [
      LatLng(-8.109520, -79.021729), // Lugar 1
      LatLng(-8.113490, -79.027724), // Lugar 2
      LatLng(-8.107800, -79.024700), // Lugar 3
      LatLng(-8.111600, -79.028100), // Lugar 4
      LatLng(-8.108900, -79.022300), // Lugar 5
    ];

    final placeInfos = [
      'Restaurante Las Delicias',
      'Plaza de Armas',
      'Catedral de Trujillo',
      'Centro Comercial Real Plaza',
      'Museo de Arqueología'
    ];

    for (int i = 0; i < nearbyPlaces.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: nearbyPlaces[i],
          infoWindow: InfoWindow(
            title: 'Lugar ${i + 1}',
            snippet: placeInfos[i],
          ),
          onTap: () {
            setState(() {
              _selectedPlace = placeInfos[i];
            });
            _showBottomSheet();
          },
        ),
      );
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.4, // Menos de la mitad de la pantalla
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del lugar',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                _selectedPlace,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción:',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Este es un lugar destacado cerca de Trujillo. Ven a explorar sus características únicas y disfruta del ambiente.',
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps - Ubicación y Marcadores")),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
        markers: Set.from(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
