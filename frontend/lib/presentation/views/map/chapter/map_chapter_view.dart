import 'dart:async';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/chapter/map/card_chapter_map.dart';
import 'package:bookie/presentation/widgets/shared/message_empty_chapter.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapChapterView extends ConsumerStatefulWidget {
  // final int storyId;
  static const String name = 'map-chapter-view';
  final double latitudeFromRouter;
  final double longitudeFromRouter;
  // final String titleFromRouter;
  final int currentChapter;
  final int storyId;

  const MapChapterView(
      {super.key,
      required this.latitudeFromRouter,
      required this.longitudeFromRouter,
      required this.currentChapter,
      // required this.titleFromRouter,
      required this.storyId});

  @override
  ConsumerState<MapChapterView> createState() => _MapChapterViewState();
}

class _MapChapterViewState extends ConsumerState<MapChapterView> {
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customChapterIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customUserIcon = BitmapDescriptor.defaultMarker;
  bool isLoading = true;
  bool isLoadingMap = true;
  late final double latitude;
  late final double longitude;
  late final String title;
  late int currentChapterChange;
  late double latitudeUser;
  late double longitudeUser;
  late StreamSubscription<Position> positionStream;
  final List<LatLng> _markersChapters = [];
  final SwiperController _controllerSwiper = SwiperController();

// TODO: MEJORAR CUANDO CARGA EL MAPA PORQUE SE PODRIA CARGAR EL MAPA POR MIENTRAS HASTA ENCONTRAR LA UBICACION DEL USUARIO U OTROS ELEMENTOS CREO REVISARLO
  Future<void> locationUser() async {
    try {
      final userPosition = await determinePosition();

      // Verificar si el widget sigue montado antes de modificar su estado.
      if (mounted) {
        setState(() {
          latitudeUser = userPosition.latitude;
          longitudeUser = userPosition.longitude;
        });
      }
    } catch (e) {
      print('Error al determinar la posición: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al determinar la posición')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMap = false;
        });
      }
    }
  }

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

  void customMarkerChapters() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_chapter.webp')
        .then(
      (value) {
        customChapterIcon = value;
      },
    );
  }

  void customMarkerUser() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(75, 75)),
            'assets/images/marker_user_location.webp')
        .then(
      (value) {
        // setState(() {
        customUserIcon = value;
        // });
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
    print("ISCURRENTCHAPTER MAP: ${widget.currentChapter}");

    super.initState();
    customMarkerChapters();
    customMarkerUser();
    locationUser();
    latitude = widget.latitudeFromRouter;
    longitude = widget.longitudeFromRouter;
    // title = widget.titleFromRouter;
    currentChapterChange = widget.currentChapter;
    _loadChapters();
    startTrackingUser();
  }

  void changePositionChapter({
    required double latitude,
    required double longitude,
  }) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(latitude, longitude), // Centrar en la ubicación actual
      ),
    );
  }

  void startTrackingUser() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Notificar cambios después de 10 metros
      ),
    ).listen((Position position) {
      setState(() {
        latitudeUser = position.latitude;
        longitudeUser = position.longitude;
      });
    });
  }

  @override
  void dispose() {
    positionStream.cancel(); // Cancelar el stream al salir
    super.dispose();
  }

  void refreshLocation(dynamic value) {
    value.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final chapters = ref.watch(chapterProvider);

    return SafeArea(
      child: Stack(
        children: [
          isLoadingMap
              ? Center(child: SpinKitFadingCircle(color: colors.primary))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        latitude, longitude), // Posición inicial del mapa
                    zoom: 17,
                    tilt: 50,
                    bearing: 0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // addMarker(); // Agregar marcador cuando el mapa se cree
                  },
                  markers: {
                    // MARKER user
                    Marker(
                        markerId: const MarkerId('user-location'),
                        position: LatLng(latitudeUser,
                            longitudeUser), // Posición inicial del marcador
                        icon: customUserIcon,
                        infoWindow: InfoWindow(
                          title: "Usuario",
                          snippet: 'Ubicación del usuario',
                        ),
                        onTap: () {
                          locationUser();
                        }),

                    // MARKER chapter
                    if (chapters.isNotEmpty)
                      ...chapters.map(
                        (chapter) => Marker(
                            markerId:
                                MarkerId('chapter-location-${chapter.id}'),
                            position: LatLng(
                                chapter.latitude,
                                chapter
                                    .longitude), // Posición inicial del marcador
                            icon: customChapterIcon,
                            infoWindow: InfoWindow(
                              title: chapter.title,
                              snippet:
                                  'Ubicación del capítulo ${chapters.indexOf(chapter) + 1}',
                            ),
                            onTap: () async {
// Animación manual para moverse al capítulo deseado lentamente
                              await Future.delayed(
                                  const Duration(milliseconds: 300), () {
                                _controllerSwiper.move(
                                    chapters.indexOf(chapter),
                                    animation: true);
                              });

                              setState(() {
                                currentChapterChange =
                                    chapters.indexOf(chapter);
                              });
                            }),
                      ),

                    // Marker(
                    //   markerId: const MarkerId('selected-location'),
                    //   position: LatLng(
                    //       latitude, longitude), // Posición inicial del marcador
                    //   icon: customChapterIcon,
                    //   infoWindow: InfoWindow(
                    //     title: title,
                    //     snippet: 'Ubicación del capítulo',
                    //   ),
                    // ),
                  }, // Selecciona el tipo de mapa
                  zoomControlsEnabled: true, // Activa los botones de zoom
                  myLocationButtonEnabled: true, // Activa el botón de ubicación
                  mapToolbarEnabled:
                      true, // Habilita la barra de herramientas de Google Maps
                  myLocationEnabled:
                      false, // Muestra la ubicación actual (requiere permisos)
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
                      'Capítulo ${currentChapterChange + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                    backgroundColor: isDarkmode ? Colors.black : Colors.white,
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
                        child:
                            Text("Cargando capítulos...")) // Muestra cargando
                    : chapters.isEmpty
                        ? MessageEmptyChapter()
                        : Swiper(
                            itemCount: chapters.length,
                            index: currentChapterChange,
                            controller: _controllerSwiper,
                            onIndexChanged: (index) {
                              setState(() {
                                currentChapterChange = index;
                                changePositionChapter(
                                    latitude: chapters[index].latitude,
                                    longitude: chapters[index].longitude);
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final chapter = chapters[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 25),
                                child: CardChapterMap(
                                  title: chapter.title,
                                  index: index,
                                  latitude: chapter.latitude,
                                  longitude: chapter.longitude,
                                  storyId: widget.storyId,
                                  // onAction: refreshLocation,
                                ),
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
                            control: chapters.length > 1
                                ? SwiperControl(
                                    color:
                                        colors.primary, // Color de las flechas
                                    size: 30, // Tamaño de las flechas
                                  )
                                : null,
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
                    backgroundColor: isDarkmode ? Colors.black : Colors.white,
                  ),
                  icon: Icon(
                    Icons.my_location,
                    color: colors.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    // Función para centrar en la ubicación actual
                    changePositionChapter(
                        latitude: latitudeUser, longitude: longitudeUser);
                  },
                ),
                const SizedBox(height: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: isDarkmode ? Colors.black : Colors.white,
                  ),
                  icon: Icon(
                    Icons.menu_book,
                    color: colors.primary,
                    size: 32,
                  ),
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 300), () {
                      _controllerSwiper.move(widget.currentChapter,
                          animation: true);
                    });
                    // Función para centrar en la ubicación actual
                    setState(() {
                      currentChapterChange = widget.currentChapter;
                    });
                    changePositionChapter(
                        latitude: latitude, longitude: longitude);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
