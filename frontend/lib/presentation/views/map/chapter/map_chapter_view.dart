import 'package:bookie/config/constants/general.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/chapter/map/card_chapter_map.dart';
import 'package:bookie/presentation/widgets/shared/message_empty_chapter.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapChapterView extends ConsumerStatefulWidget {
  // final int storyId;
  static const String name = 'map-chapter-view';
  final double latitudeFromRouter;
  final double longitudeFromRouter;
  final String titleFromRouter;
  final int currentChapter;
  final int storyId;

  const MapChapterView(
      {super.key,
      required this.latitudeFromRouter,
      required this.longitudeFromRouter,
      required this.currentChapter,
      required this.titleFromRouter,
      required this.storyId});

  @override
  ConsumerState<MapChapterView> createState() => _MapChapterViewState();
}

class _MapChapterViewState extends ConsumerState<MapChapterView> {
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  // final Set<Marker> _markers = {};
  late Future<bool> isUnlockedFuture;
  bool isLoading = true;
  late final double latitude;
  late final double longitude;
  late final String title;

  Future<void> _loadChapters() async {
    try {
      // Obtener los capítulos usando el provider
      await ref.read(chapterProvider.notifier).getChapters(widget.storyId);

      // final chapters = ref.watch(chapterProvider);

      // if (chapters.isNotEmpty) {
      //   isUnlockedFuture = isChapterUnlocked();
      // }
    } catch (e) {
      // Manejo de errores
      print("Error al cargar los capítulos: $e");
    } finally {
      setState(() {
        isLoading =
            false; // Establecer la carga en false cuando termine la solicitud
      });
    }
  }

  Future<bool> isChapterUnlocked(
    double latitude,
    double longitude,
  ) async {
    try {
      final userPosition = await determinePosition();
      final double radius = GeneralConstants.radius;
      final isUnlocked = isWithinRadius(
        userPosition,
        latitude,
        longitude,
        radius,
      );

      return isUnlocked;
    } catch (e) {
      print('Error al determinar la posición: $e');
      return false;
    }
  }

  //   Future<bool> isChapterUnlocked(
  //   bool latitude,
  //   bool longitude,
  // ) async {
  //   try {
  //     final userPosition = await determinePosition();
  //     final double radius = GeneralConstants.radius;
  //     final isUnlocked = isWithinRadius(
  //       userPosition,
  //       widget.latitude,
  //       widget.longitude,
  //       radius,
  //     );

  //     return isUnlocked;
  //   } catch (e) {
  //     print('Error al determinar la posición: $e');
  //     return false;
  //   }
  // }

  void customMarker() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_story_noread.webp')
        .then(
      (value) {
        customIcon = value;
      },
    );
  }

  // void addMarker() async {
  //   customMarker();
  //   Marker marker = Marker(
  //     markerId: const MarkerId('custom_marker'),
  //     position: LatLng(latitude, longitude),
  //     icon: customIcon,
  //     infoWindow: const InfoWindow(
  //       title: 'Marcador Personalizado',
  //       snippet: 'Este es un marcador con un ícono cargado dinámicamente.',
  //     ),
  //   );

  //   setState(() {
  //     _markers.add(marker);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    latitude = widget.latitudeFromRouter;
    longitude = widget.longitudeFromRouter;
    title = widget.titleFromRouter;
    isUnlockedFuture = isChapterUnlocked(
      latitude,
      longitude,
    );
    // customMarker();
    _loadChapters();
  }

  void refreshLocation() {
    setState(() {
      isUnlockedFuture = isChapterUnlocked(
        latitude,
        longitude,
      ); // Actualiza el estado para recalcular
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final chapters = ref.watch(chapterProvider);

    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude), // Posición inicial del mapa
              zoom: 18,
              tilt: 50,
              bearing: 0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              // addMarker(); // Agregar marcador cuando el mapa se cree
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: LatLng(
                    latitude, longitude), // Posición inicial del marcador
                icon: customIcon,
                infoWindow: InfoWindow(
                  title: title,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 370,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 90, horizontal: 10),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator()) // Muestra cargando
                    : chapters.isEmpty
                        ? MessageEmptyChapter()
                        : Swiper(
                            itemCount: chapters.length,
                            index: widget.currentChapter - 2,
                            itemBuilder: (BuildContext context, int index) {
                              final chapter = chapters[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 25),
                                child: CardChapterMap(
                                    title: chapter.title,
                                    index: index + 1,
                                    isBlocked: isUnlockedFuture),
                              );
                            },
                            pagination: SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                activeColor: colors
                                    .primary, // Color de los puntos activos
                                color: isDarkmode
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                                size: 8.0, // Tamaño de los puntos inactivos
                                activeSize:
                                    10.0, // Tamaño de los puntos activos
                              ),
                            ),
                            loop: false, // Bucle infinito
                            // Habilita la paginación
                            control: SwiperControl(
                              color: colors.primary, // Color de las flechas
                              size: 30, // Tamaño de las flechas
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
                    refreshLocation();
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
                        LatLng(latitude,
                            longitude), // Centrar en la ubicación actual
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          //  Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 80),
          //   child: CardChapterMap(
          //     title: widget.title,
          //     index: widget.currentChapter,
          //   ),
          // ),
        ],
      ),
    );
  }
}
