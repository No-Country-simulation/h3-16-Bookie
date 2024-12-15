import 'dart:async';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/config/helpers/get_address.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/country_provider.dart';
import 'package:bookie/presentation/providers/location_provider.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/story/map/card_chapter_map.dart';
import 'package:bookie/presentation/widgets/search/search_input.dart';
import 'package:bookie/presentation/widgets/shared/show_error.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends ConsumerStatefulWidget {
  // final int storyId;
  static const String name = 'map-screen';

  const MapScreen({
    super.key,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapChapterViewState();
}

class _MapChapterViewState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController; // Controlador del mapa
  BitmapDescriptor customUserIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customStoryIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customChapterIcon = BitmapDescriptor.defaultMarker;
  late Future<bool> isUnlockedFuture;
  bool isLoading = true;
  bool isLoadingMap = true;
  double? latitudeUser;
  double? longitudeUser;
  final String title = "title";
  late StreamSubscription<Position> positionStream;
  bool isCardVisible = false;
  bool isSwiperVisible = false;
  // final List<LatLng> _markersChapters = [];
  // bool showMarkerChapters = false;
  bool isViewListPredictions = true;
  Story? currentStory;
  int? currentChapterChange;
  final SwiperController _controllerSwiper = SwiperController();
  String? selectedCountryOrProvince;

  void toggleCard() {
    setState(() {
      isCardVisible = !isCardVisible;
    });
  }

  void toggleSwiper() {
    setState(() {
      isSwiperVisible = !isSwiperVisible;
    });
  }

  void toggleViewListPredictions() {
    setState(() {
      isViewListPredictions = !isViewListPredictions;
    });
  }

  void goAdress(String address) async {
    try {
      final locationAddress = await latLongToAddress(address);

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationAddress.latitude,
              locationAddress.longitude), // Centrar en la ubicación actual
        ),
      );

    } catch (e) {
      // Manejo de errores
    }
  }

  Future<void> _loadChapters() async {
    try {} catch (e) {
      // Manejo de errores
    } finally {
      setState(() {
        isLoading =
            false; // Establecer la carga en false cuando termine la solicitud
      });
    }
  }

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
          isLoadingMap = false;
        });
      }
    }
  }

  void customMarkerStories() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(60, 60)),
            'assets/images/marker_story.webp')
        .then(
      (value) {
        setState(() {
          customStoryIcon = value;
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

  void customMarkerStoryChapters() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 50)),
            'assets/images/marker_chapter.webp')
        .then(
      (value) {
        setState(() {
          customChapterIcon = value;
        });
      },
    );
  }

  void startTrackingUser() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Notificar cambios después de 10 metros
      ),
    ).distinct().listen((Position position) {
      // Mueve la cámara suavemente
      // _mapController?.animateCamera(
      //   CameraUpdate.newLatLng(
      //     LatLng(position.latitude, position.longitude),
      //   ),
      // );

      setState(() {
        latitudeUser = position.latitude;
        longitudeUser = position.longitude;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    customMarkerUser();
    customMarkerStories();
    customMarkerStoryChapters();
    locationUser();
    _loadChapters();
    startTrackingUser(); // Iniciar ubicacion del usuario tiempo real
  }

  @override
  void dispose() {
    positionStream.cancel(); // Cancelar el stream al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final currentPosition = ref.watch(locationProvider);
    final countries =
        ref.watch(countryProvinceProvider.notifier).getCountries();
    final provinces =
        ref.watch(countryProvinceProvider.notifier).getProvinces();
    final stories = ref.watch(storiesAllProvider);
    final filterState = ref.watch(filterCountryOrProvinceProvider);
    final selectedCountryOrProvinceFilterProvider = filterState.provider;

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

    return SafeArea(
      child: Stack(
        children: [
          currentPosition.latitude == 0.0 && currentPosition.longitude == 0.0
              ? Center(
                  child: SpinKitFadingCircle(
                    color: colors.primary,
                    size: 50.0,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    // LatLng(latitudeUser,
                    //     longitudeUser), // Posición inicial del mapa
                    zoom: 14,
                    // tilt: 50,
                    // bearing: 0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  }, // Selecciona el tipo de mapa
                  onTap: (_) {
                    if (isCardVisible) {
                      toggleCard();
                    }
                    if (isSwiperVisible) {
                      toggleSwiper();
                    }
                    if (isViewListPredictions) {
                      toggleViewListPredictions();
                    }
                    setState(() {
                      selectedCountryOrProvince = null;
                    });
                  },
                  zoomControlsEnabled: true, // Activa los botones de zoom
                  myLocationButtonEnabled: true, // Activa el botón de ubicación
                  mapToolbarEnabled:
                      true, // Habilita la barra de herramientas de Google Maps
                  // myLocationEnabled:
                  //     true, // Muestra la ubicación actual - circulo azul
                  style: isDarkmode ? mapOptionDark : "",
                  // polylines: Set<Polyline>.of(polylinesStory.values),
                  markers: {
                    if (!isLoadingMap &&
                        latitudeUser != null &&
                        longitudeUser != null)
                      Marker(
                          markerId: const MarkerId('user-location'),
                          position: LatLng(latitudeUser!,
                              longitudeUser!), // Posición inicial del marcador
                          icon: customUserIcon,
                          infoWindow: InfoWindow(
                            title: "Usuario actual",
                            // snippet: 'Ubicación del usuario',
                          ),
                          onTap: () {
                            locationUser();
                          }),

                    if (isLoadingMap)
                      Marker(
                          markerId: const MarkerId('user-location-temporal'),
                          position: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          icon: customUserIcon,
                          infoWindow: InfoWindow(
                            title: "Usuario actual",
                            // snippet: 'Ubicación del usuario',
                          ),
                          onTap: () {
                            // locationUser();
                          }),
                    // ...Set.from(_markers),
                    if (stories.isNotEmpty)
                      ...stories.map((story) {
                        return Marker(
                          markerId: MarkerId('marker_story_${story.id}'),
                          position: LatLng(story.chapters[0].latitude,
                              story.chapters[0].longitude),
                          icon: customStoryIcon,
                          infoWindow: InfoWindow(title: story.title),
                          onTap: () {
                            setState(() {
                              if (!isCardVisible) {
                                toggleCard();
                              }
                              if (isSwiperVisible) {
                                toggleSwiper();
                              }
                              currentStory = story;
                            });
                            // _addMarkersChapters(i);
                          },
                        );
                      }),

                    // MARKER DE LOS CHAPTERS DE LA STORY
                    // if (showMarkerChapters)
                    //   ..._markersChapters.skip(1).map((e) => Marker(
                    //         markerId: MarkerId('marker_chapter_$e'),
                    //         position: e,
                    //         icon: customChapterIcon,
                    //         infoWindow:
                    //             InfoWindow(title: 'Title ${e.hashCode}'),
                    //         onTap: () {},
                    //       )),
                  }, //
                ),
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Container(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  height: kToolbarHeight - 10,
                  width: 260,
                  child: AppBar(
                    title: Text(
                      // 'Capítulo ${widget.currentChapter}',
                      'Mapa Historias',
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

          // autcompletado
          Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (countries.isNotEmpty)
                          ...countries.map((option) {
                            return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      currentChapterChange = -1;
                                      selectedCountryOrProvince = option.name;
                                    });
                                    ref
                                        .read(filterCountryOrProvinceProvider
                                            .notifier)
                                        .selectProvider(
                                          getStoriesByCountryNameProvider(
                                              option.name),
                                        );

                                    if (isCardVisible) {
                                      toggleCard();
                                    }
                                    if (!isSwiperVisible) {
                                      toggleSwiper();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        selectedCountryOrProvince == option.name
                                            ? colors.primary
                                            : isDarkmode
                                                ? Colors.black
                                                : Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 8.0),
                                    shadowColor:
                                        Colors.transparent, // Eliminar sombra
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Opcional, para bordes redondeados
                                    ),
                                  ),
                                  child: Text(
                                    capitalizeAllWords(option.name),
                                    style: TextStyle(
                                      color: selectedCountryOrProvince ==
                                              option.name
                                          ? Colors.black
                                          : isDarkmode
                                              ? colors.primary
                                              : Colors.black,
                                    ),
                                  ),
                                ));
                          }),
                        if (provinces.isNotEmpty)
                          ...provinces.map((option) {
                            return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      currentChapterChange = -1;
                                      selectedCountryOrProvince = option.name;
                                    });
                                    ref
                                        .read(filterCountryOrProvinceProvider
                                            .notifier)
                                        .selectProvider(
                                          getStoriesByProvinceNameProvider(
                                              option.name),
                                        );

                                    if (isCardVisible) {
                                      toggleCard();
                                    }
                                    if (!isSwiperVisible) {
                                      toggleSwiper();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        selectedCountryOrProvince == option.name
                                            ? colors.primary
                                            : isDarkmode
                                                ? Colors.black
                                                : Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 8.0),
                                    shadowColor:
                                        Colors.transparent, // Eliminar sombra
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Opcional, para bordes redondeados
                                    ),
                                  ),
                                  child: Text(
                                    capitalizeAllWords(option.name),
                                    style: TextStyle(
                                      color: selectedCountryOrProvince ==
                                              option.name
                                          ? Colors.black
                                          : isDarkmode
                                              ? colors.primary
                                              : Colors.black,
                                    ),
                                  ),
                                ));
                          }),
                      ],
                    ),
                  ),
                ),
              )),

          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SearchInput(
                isCardVisible: isCardVisible,
                isSwiperVisible: isSwiperVisible,
                toggleCard: toggleCard,
                toggleSwiper: toggleSwiper,
                isViewListPredictions: isViewListPredictions,
                toggleViewListPredictions: toggleViewListPredictions,
                goAdress: goAdress,
              ),
            ),
          ),

          // CARD DE LA STORY INDIVIDUAL
          if (currentStory != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: !isCardVisible ? 0 : 220,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: AnimatedOpacity(
                    opacity: isCardVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 20),
                        child: CardStoryMap(
                          story: currentStory ??
                              Story(
                                id: 274,
                                title: "El jinete de la historia",
                                synopsis: "Sinopsis de la historia",
                                imageUrl: "https://picsum.photos/id/1/200/300",
                                genre: Genre.cuento,
                                country: "Colombia",
                                province: "Bogotá",
                                publish: true,
                                distance: 0,
                                chapters: [
                                  Chapter(
                                    id: 1,
                                    title: "Título del capítulo",
                                    latitude: 0,
                                    longitude: 0,
                                    image:
                                        "https://picsum.photos/seed/chapter1/100",
                                    content: "Contenido del capítulo",
                                  )
                                ],
                              ),
                        )),
                  ),
                ),
              ),
            ),

          if (selectedCountryOrProvinceFilterProvider != null)
            ref.watch(selectedCountryOrProvinceFilterProvider).when(
                  data: (stories) => Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: !isSwiperVisible ? 0 : 220,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: AnimatedOpacity(
                          opacity: isSwiperVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Swiper(
                            itemCount: stories.length,
                            index: currentChapterChange,
                            controller: _controllerSwiper,
                            onIndexChanged: (index) {
                              if (stories.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("No hay historias disponibles"),
                                    backgroundColor: colors.primary,
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                currentChapterChange = index;
                                changePositionChapter(
                                    latitude:
                                        stories[index].chapters[0].latitude,
                                    longitude:
                                        stories[index].chapters[0].longitude);
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 20),
                                child: CardStoryMap(
                                  story: stories[index],
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
                            control: SwiperControl(
                              color: colors.primary, // Color de las flechas
                              size: 30, // Tamaño de las flechas
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  loading: () => Center(
                      child: SpinKitFadingCircle(
                          color: colors.primary, size: 30.0)),
                  error: (_, __) =>
                      ShowError(message: "No se encontraron resultados"),
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
                    if (!isLoadingMap &&
                        latitudeUser != null &&
                        longitudeUser != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(latitudeUser!,
                              longitudeUser!), // Centrar en la ubicación actual
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Estamos buscando tu ubicación...",
                          ),
                          backgroundColor: colors.primary,
                        ),
                      );
                    }
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
