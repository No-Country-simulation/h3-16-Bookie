import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapHistoriesPoints extends StatefulWidget {
  static const String name = 'map histories';

  const MapHistoriesPoints({super.key});

  @override
  State<MapHistoriesPoints> createState() => _MapHistoriesPointsState();
}

class _MapHistoriesPointsState extends State<MapHistoriesPoints> {
  MapboxMap? mapboxMap;
  Map<String, dynamic>? selectedHistory;

  final List<Map<String, dynamic>> histories = [
    {
      'id': '1',
      'title': 'Historia 1',
      'latitude': -8.079058,
      'longitude': -79.121091,
      'description': 'Descripción de la historia 1',
    },
    {
      'id': '2',
      'title': 'Historia 2',
      'latitude': -8.080000,
      'longitude': -79.120000,
      'description': 'Descripción de la historia 2',
    },
  ];

  // Método para crear los marcadores en el mapa
  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;

    for (var history in histories) {
      mapboxMap.annotations.createPointAnnotationManager().then(
        (pointAnnotationManager) async {
          await pointAnnotationManager.create(PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(history['longitude'], history['latitude']),
            ),
            textField: history['title'], // Texto del marcador
            textSize: 14, // Tamaño del texto
            textColor: Colors.black.value, // Color del texto
            // iconImage: "asset://assets/marker.png", // Ícono personalizado
          ));
        },
      );
    }
  }

  // Método para manejar el evento al seleccionar una historia

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historias en el Mapa'),
      ),
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        onMapCreated: _onMapCreated,
        styleUri: MapboxStyles.MAPBOX_STREETS,
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(-8.079058, -79.121091),
          ),
          zoom: 14.0,
        ),
        onTapListener: (point) {
          // Detectar si se tocó un marcador o el mapa
          // final tappedHistory = histories.firstWhere(
          //   (history) =>
          //       (history['latitude'] - point.geometry.y).abs() < 0.001 &&
          //       (history['longitude'] - point.geometry.x).abs() < 0.001,
          //   orElse: () => {},
          // );

          // if (tappedHistory.isNotEmpty) {
          //   _onHistoryTap(tappedHistory);
          // }
        },
      ),
    );
  }
}
