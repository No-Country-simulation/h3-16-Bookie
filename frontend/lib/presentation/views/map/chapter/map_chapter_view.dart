import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/chapter/map/card_chapter_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapChapterView extends StatefulWidget {
  // final int storyId;
  static const String name = 'map-chapter-view';
  final double latitude;
  final double longitude;
  final int currentChapter;
  final String title;

  const MapChapterView(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.currentChapter,
      required this.title});

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
    // _loadMapStyles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 18,
              tilt: 50,
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
                infoWindow: InfoWindow(
                  title: widget.title,
                  snippet: 'Ubicación del capítulo',
                ),
              ),
            }, // Selecciona el tipo de mapa
            zoomControlsEnabled: true, // Activa los botones de zoom
            myLocationButtonEnabled: true, // Activa el botón de ubicación
            mapToolbarEnabled:
                true, // Habilita la barra de herramientas de Google Maps
            myLocationEnabled:
                true, // Muestra la ubicación actual (requiere permisos)
            style: isDarkmode ? mapOptionDark : "",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: kToolbarHeight,
                  width: 210,
                  child: AppBar(
                    title: Text(
                      'Capítulo ${widget.currentChapter}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    backgroundColor: isDarkmode ? Colors.black54 : Colors.white,
                    centerTitle: true,
                    elevation: 5,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 12,
            child: Column(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: isDarkmode ? Colors.black38 : Colors.white,
                  ),
                  icon: Icon(
                    Icons.sync,
                    color: colors.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    // Función para centrar en la ubicación actual
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(widget.latitude, widget.longitude),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: isDarkmode ? Colors.black38 : Colors.white,
                  ),
                  icon: Icon(
                    Icons.menu_book,
                    color: colors.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    // Función para centrar en la ubicación actual
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(widget.latitude, widget.longitude),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70, // Espacio de 30 desde la parte inferior
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: CardChapterMap(
                title: widget.title,
                index: widget.currentChapter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
