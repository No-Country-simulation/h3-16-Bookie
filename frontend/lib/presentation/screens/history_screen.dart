import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HistoryScreen extends StatefulWidget {
  final String historyId; // Recibimos el id desde la ruta
  static const String name = 'history';

  const HistoryScreen({super.key, required this.historyId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PageController _pageController = PageController();
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = {};

  void _addMarker() {
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

  @override
  void initState() {
    super.initState();
    customMarker();
  }

  // Icono del marcador
  void customMarker() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_story_noread.webp')
        .then(
      (value) {
        customIcon = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = [...readStories, ...unreadStories].firstWhere(
      (history) => history['id'] == widget.historyId,
    );

    final colors = Theme.of(context).colorScheme;

    // Función para abrir Google Maps con un recorrido desde la ubicación actual hasta el destino
    Future<void> openGoogleMaps() async {
      try {
        // Obtener la ubicación actual del usuario
        Position position = await determinePosition();

        //todo: posiblemente quitarlo sino revisar - para mostrar la distancia si va caminando o en auto antes de ir a google maps
        final distanceGeolocator = distanceFromGeolocator(position, history);

        final currentLocation = "${position.latitude},${position.longitude}";

        final googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=$currentLocation&destination=${history['latitud']},${history['longitud']}&travelmode=${distanceGeolocator > 500 ? 'driving' : 'walking'}";

        // Intentar abrir Google Maps
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir Google Maps';
        }
      } catch (e) {
        if (context.mounted) {
          print('Error al obtener la ubicación: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener la ubicación')),
          );
        }
      }
    }

    // Función para calcular si el usuario está dentro del rango permitido
    bool isWithinRadius(Position userPosition, double targetLat,
        double targetLon, double radius) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        targetLat,
        targetLon,
      );

      return distance <= radius;
    }

    // Función para obtener capítulos desbloqueados basados en la ubicación
    Future<List<Map<String, dynamic>>> getUnlockedChapters() async {
      try {
        final userPosition = await determinePosition();
        const double radius = 15; // Radio de 20 metros
        final chapters = mockChapters.map((chapter) {
          final isUnlocked = isWithinRadius(
            userPosition,
            chapter['latitude'],
            chapter['longitude'],
            radius,
          );

          return {
            ...chapter,
            'isUnlocked': isUnlocked,
          };
        }).toList();

        return chapters;
      } catch (e) {
        print('Error al determinar la posición: $e');
        return [];
      }
    }

    return Scaffold(
      appBar: !_pageController.hasClients
          ? AppBar(
              title: Text('History ${widget.historyId}'),
            )
          : null,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListView(
            children: [
              // Hero Image (25% de la pantalla)
              Hero(
                tag: 'hero-image-${widget.historyId}',
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(history['imageUrl'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black54, // Fondo oscuro para visibilidad
                    child: Center(
                      child: Text(
                        history['title'] as String, // Título dinámico
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sinopsis
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sinopsis',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esta es la sinopsis de la historia que tiene una narrativa emocionante sobre el viaje que vas a realizar. Prepárate para una gran aventura.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // Duración del viaje y botón de Google Maps
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey),
                            SizedBox(width: 4.0),
                            Text('Duración del viaje: 30 min'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.add_road, color: Colors.grey),
                            SizedBox(width: 4.0),
                            Text('10 km de recorrido'),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: openGoogleMaps,
                      child: const Text('Ir a Google Maps'),
                    ),
                  ],
                ),
              ),

              // Mapa
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mapa',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // Cambiar al índice del mapa en el PageView
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          'https://maps.googleapis.com/maps/api/staticmap?center=${history['latitud']},${history['longitud']}&zoom=15&size=600x300&maptype=roadmap&markers=icon:https://res.cloudinary.com/dlixnwuhi/image/upload/v1732358774/e9whpwiyvtdwn8gveven.png%7Clabel:S%7C${history['latitud']},${history['longitud']}&key=${Environment.theGoogleMapsApiKey}',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Text('Error al cargar el mapa'));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lugares cercanos
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lugares',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const ListTile(
                      title: Text('Lugar 1'),
                      subtitle: Text(
                          'Descripción breve del lugar. Lorem ipsum dolor sit amet.'),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capítulos',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: getUnlockedChapters(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                            child: Text('Error al cargar los capítulos'),
                          );
                        }

                        final chapters = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return ListTile(
                              title: Text(chapter['title']),
                              subtitle: chapter['isUnlocked']
                                  ? const Text('Desbloqueado')
                                  : const Text(
                                      'Bloqueado - Acércate al lugar para desbloquear'),
                              trailing: Icon(
                                chapter['isUnlocked']
                                    ? Icons.lock_open
                                    : Icons.lock,
                                color: chapter['isUnlocked']
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60),
              // mostrando temporalmente los capitulos para hacer el mostrado o bloqueado de historias cuando el suusario esta cerca a la ubicación
            ],
          ),
          // Página del mapa interactivo
          SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(history['latitud'] as double,
                        history['longitud'] as double),
                    zoom: 17,
                    // tilt: 60,
                    // bearing: 180,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _addMarker(); // Agregar marcador cuando el mapa se cree
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: LatLng(history['latitud'] as double,
                          history['longitud'] as double),
                      icon: customIcon,
                      draggable: true,
                      onDragEnd: (value) {
                        // Actualiza la ubicación seleccionada
                        print('DragEnd: ${value.latitude}, ${value.longitude}');
                      },
                      infoWindow: InfoWindow(
                        title: 'Seleccionado',
                        snippet: 'Ubicación de la historia',
                      ),
                    ),
                  },
                ),
                // Positioned(
                //   top: 16,
                //   left: 16,
                //   child: FloatingActionButton(
                //     backgroundColor: colors.primary,
                //     onPressed: () {
                //       // Volver a la página principal
                //       _pageController.animateToPage(
                //         0,
                //         duration: const Duration(milliseconds: 300),
                //         curve: Curves.easeInOut,
                //       );
                //     },
                //     child: const Icon(Icons.arrow_back),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: openGoogleMaps,
        tooltip: 'Start',
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        child: const Text('Start'),
      ),
    );
  }
}

// Datos mockeados para los capítulos
const List<Map<String, dynamic>> mockChapters = [
  {
    'id': '1',
    'title': 'Capítulo 1: Inicio de la aventura',
    "latitude": -8.120251,
    "longitude": -79.045744
  },
  {
    'id': '2',
    'title': 'Capítulo 2: Encuentro inesperado',
    'latitude': -8.120438,
    'longitude': -79.045685
  },
  {
    'id': '3',
    'title': 'Capítulo 3: El desafío',
    'latitude': -8.121115,
    'longitude': -79.045816,
  },
];
