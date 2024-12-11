import 'dart:async';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:bookie/presentation/providers/location_provider.dart';
import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/chapter/map/card_chapter_map.dart';
import 'package:bookie/presentation/widgets/shared/message_empty_chapter.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool isLoadingLocationUser = true;
  late final double latitude;
  late final double longitude;
  late final String title;
  late int currentChapterChange;
  double? latitudeUser;
  double? longitudeUser;
  late StreamSubscription<Position> positionStream;
  final SwiperController _controllerSwiper = SwiperController();

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al determinar la posición')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLocationUser = false;
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
    } finally {
      setState(() {
        isLoading =
            false; // Establecer la carga en false cuando termine la solicitud
      });
    }
  }

  void customMarkerChapters() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(65, 65)),
            'assets/images/marker_chapter.webp')
        .then(
      (value) {
        setState(() {
          customChapterIcon = value;
        });
      },
    );
  }

  void customMarkerUser() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(65, 65)),
            'assets/images/marker_user_location.webp')
        .then(
      (value) {
        setState(() {
          customUserIcon = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    customMarkerChapters();
    customMarkerUser();
    locationUser();
    // initFunctions();
    // Inicializa las variables en 0 o en un valor predeterminado
    latitude = widget.latitudeFromRouter;
    longitude = widget.longitudeFromRouter;
    currentChapterChange = widget.currentChapter;
    _loadChapters();
    startTrackingUser();
    // title = widget.titleFromRouter;
  }

  // Future<void> initFunctions() async {
  //   await locationUser();
  //   startTrackingUser();
  // }

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
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Notificar cambios después de 10 metros
      ),
    ).distinct().listen((Position position) {
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
    final currentPosition = ref.watch(locationProvider);

    return SafeArea(
      child: Stack(
        children: [
          // isLoadingLocationUser
          // ? Center(child: SpinKitFadingCircle(color: colors.primary))
          // :
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude), // Posición inicial del mapa
              zoom: 15,
              // tilt: 50,
              // bearing: 0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              // addMarker(); // Agregar marcador cuando el mapa se cree
            },
            markers: {
              // MARKER user
              if (!isLoadingLocationUser &&
                  latitudeUser != null &&
                  longitudeUser != null)
                Marker(
                    markerId: const MarkerId('user-location'),
                    position: LatLng(latitudeUser!,
                        longitudeUser!), // Posición inicial del marcador
                    icon: customUserIcon,
                    infoWindow: InfoWindow(
                      title: "Ubicación actual",
                      // snippet: 'Ubicación del usuario',
                    ),
                    onTap: () {
                      locationUser();
                    }),

              if (isLoadingLocationUser)
                Marker(
                    markerId: const MarkerId('user-location-temporal'),
                    position: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    icon: customUserIcon,
                    infoWindow: InfoWindow(
                      title: "Ubicación actual",
                      // snippet: 'Ubicación del usuario',
                    ),
                    onTap: () {
                      // locationUser();
                    }),

              // MARKER chapter
              if (chapters.isNotEmpty)
                ...chapters.map(
                  (chapter) => Marker(
                      markerId: MarkerId('chapter-location-${chapter.id}'),
                      position: LatLng(chapter.latitude,
                          chapter.longitude), // Posición inicial del marcador
                      icon: customChapterIcon,
                      infoWindow: InfoWindow(
                        title: chapter.title,
                        // snippet:
                        //     'Ubicación del capítulo ${chapters.indexOf(chapter) + 1}',
                      ),
                      onTap: () async {
// Animación manual para moverse al capítulo deseado lentamente
                        await Future.delayed(const Duration(milliseconds: 300),
                            () {
                          _controllerSwiper.move(chapters.indexOf(chapter),
                              animation: true);
                        });

                        setState(() {
                          currentChapterChange = chapters.indexOf(chapter);
                        });
                      }),
                ),
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
                      textAlign: TextAlign.center,
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
                                  chapterId: chapter.id,
                                  index: index,
                                  title: chapter.title,
                                  latitude: chapter.latitude,
                                  longitude: chapter.longitude,
                                  storyId: widget.storyId,
                                  imageUrl: chapter.image ?? "sin-imagen",
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
                    if (!isLoadingLocationUser &&
                        latitudeUser != null &&
                        longitudeUser != null) {
                      changePositionChapter(
                          latitude: latitudeUser!, longitude: longitudeUser!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Estamos buscando tu ubicación...",
                        ),
                        backgroundColor: colors.primary,
                      ));
                    }
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
