import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapHistories3D extends StatefulWidget {
  const MapHistories3D({super.key});

  @override
  State<MapHistories3D> createState() => _MapHistories3DState();
}

class _MapHistories3DState extends State<MapHistories3D> {
  MapboxMap? mapboxMap;
  geolocator.Position? userPosition;
  bool isLoading = true; // Loader control
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      // Verificar permisos
      geolocator.LocationPermission permission =
          await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          setState(() {
            isLoading = false;
            errorMessage = 'Permiso de ubicación denegado.';
          });
          return;
        }
      }
      if (permission == geolocator.LocationPermission.deniedForever) {
        setState(() {
          isLoading = false;
          errorMessage =
              'Permiso de ubicación denegado permanentemente. Habilítelo desde la configuración.';
        });
        return;
      }

      // Obtener la ubicación actual
      var position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      setState(() {
        userPosition = position;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al obtener la ubicación: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Mostrar un loader mientras se obtiene la ubicación
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      // Mostrar mensaje de error si algo falla
      return Center(
        child: Text(errorMessage!),
      );
    }

    // Usar la posición del usuario para centrar el mapa
    final position = Position(userPosition!.longitude, userPosition!.latitude);

    return SafeArea(
      child: Stack(
        children: [
          // Mapa
          MapWidget(
            cameraOptions: CameraOptions(
              center: Point(coordinates: position),
              zoom: 18.5,
              bearing: 50,
              pitch: 40,
            ),
            key: const ValueKey<String>('mapWidget'),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          // Botón flotante para refrescar la ubicación
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isLoading = true; // Mostrar loader nuevamente
                });
                _getUserLocation(); // Refrescar ubicación
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await addModelLayer();
  }

  Future<void> addModelLayer() async {
    if (mapboxMap == null) {
      throw Exception("MapboxMap no está listo.");
    }

    // Configuración del punto del modelo en la ubicación del usuario
    final value = Point(
      coordinates: Position(userPosition!.longitude, userPosition!.latitude),
    );

    const buggyModelId = "model-buggy-id";
    const buggyModelUri =
        // "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/CesiumMan/glTF/CesiumMan.gltf";
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";

    await mapboxMap?.style.addStyleModel(buggyModelId, buggyModelUri);
    await mapboxMap?.style
        .addSource(GeoJsonSource(id: "sourceId", data: json.encode(value)));

    var modelLayer = ModelLayer(id: "modelLayer-buggy", sourceId: "sourceId");
    modelLayer.modelId = buggyModelId;
    modelLayer.modelScale = [0.08, 0.08, 0.08];
    modelLayer.modelRotation = [0, 0, 90];
    modelLayer.modelType = ModelType.COMMON_3D;

    await mapboxMap?.style.addLayer(modelLayer);
  }
}
