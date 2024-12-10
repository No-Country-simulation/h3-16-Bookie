import 'dart:async';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/providers/location_provider.dart';
import 'package:bookie/presentation/views/map/google_maps_dark.dart';
import 'package:bookie/presentation/widgets/cards/story/map/card_chapter_map.dart';
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

  final TextEditingController _controller = TextEditingController();
  List<String> countries = [
    'Argentina',
    'Brasil',
    'Chile',
    'Colombia',
    'Perú',
    'México'
  ];
  List<String> cities = [
    'Buenos Aires',
    'São Paulo',
    'Santiago',
    'Lima',
    'Bogotá',
    'Ciudad de México'
  ];

  late Future<bool> isUnlockedFuture;
  bool isLoading = true;
  bool isLoadingMap = true;
  double? latitudeUser;
  double? longitudeUser;
  final String title = "title";
  late StreamSubscription<Position> positionStream;
  bool isCardVisible = false;
  bool isSwiperVisible = false;
  final List<LatLng> _markersChapters = [];
  bool showMarkerChapters = false;
  // Map<PolylineId, Polyline> polylinesStory = {};

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

// TODO REVISAR SI MEJOR CARGAR LOS ICONOS DEL MAPA DE FORMA ASINCRONA
//   Future<void> customMarkerStories() async {
//    customStoryIcon = await BitmapDescriptor.fromAssetImage(
//      const ImageConfiguration(size: Size(65, 65)),
//      'assets/images/marker_story.webp',
//    );
// }

  Future<void> _loadChapters() async {
    try {
      // Obtener los capítulos usando el provider
      // await ref.read(chapterProvider.notifier).getChapters(widget.storyId);

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

  // Future<List<LatLng>> fetchPolylinePoints({
  //   required double latitudeDestination,
  //   required double longitudeDestination,
  // }) async {
  //   try {
  //     final polylinePoints = PolylinePoints();

  //     final result = await polylinePoints.getRouteBetweenCoordinates(
  //         googleApiKey: Environment.theGoogleMapsApiKey,
  //         request: PolylineRequest(
  //           origin: PointLatLng(latitudeUser, longitudeUser),
  //           destination: PointLatLng(latitudeDestination, longitudeDestination),
  //           mode: TravelMode.driving,
  //         ));

  //     if (result.points.isNotEmpty) {
  //       final points = result.points
  //           .map((point) => LatLng(point.latitude, point.longitude))
  //           .toList();

  //       return points;
  //     } else {
  //       throw Exception("No se encontraron puntos");
  //     }
  //   } catch (e) {
  //     print("Error al obtener los puntos del polyline: $e");
  //     return [];
  //   }
  // }

  void _showDistance() {
    // TODO FALTA MOSTRAR LA DISTANCIA Y PONER EN UN TEXTO QUE APARECE TU ME ENTIENDES ESTA FACIL
  }

  // Future<void> generatePolylineFromPoints(
  //     {required List<LatLng> polylineCoordinates}) async {
  //   try {
  //     const id = PolylineId("polyline");
  //     final colors = Theme.of(context).colorScheme;

  //     final polyline = Polyline(
  //       polylineId: id,
  //       points: polylineCoordinates,
  //       color: colors.primary,
  //       width: 5,
  //       consumeTapEvents: true,
  //       onTap: () {
  //         _showDistance(); // Método para manejar el mensaje
  //       },
  //     );

  //     setState(() {
  //       polylinesStory[id] = polyline;
  //     });
  //   } catch (e) {
  //     throw Exception("Error al generar el polyline");
  //   }
  // }

  // Future<void> initializePolyline(
  //     {required double latitudeDestination,
  //     required double longitudeDestination}) async {
  //   try {
  //     // update de la posición del usuario
  //     await locationUser();

  //     final coordinates = await fetchPolylinePoints(
  //       latitudeDestination: latitudeDestination,
  //       longitudeDestination: longitudeDestination,
  //     );

  //     await generatePolylineFromPoints(polylineCoordinates: coordinates);
  //   } catch (e) {
  //     print("Error al inicializar el polyline: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error al generar el recorrido')),
  //     );
  //   }
  // }

// TODO REVISAR SI CAMBIAR DE ICONO DE LOS CHAPTERS
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
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );

      setState(() {
        latitudeUser = position.latitude;
        longitudeUser = position.longitude;
      });
    });
  }

  // void _addNearbyMarkers() {
  final nearbyPlaces = [
    LatLng(-8.120775, -79.044919), // Lugar 1
    LatLng(-8.113490, -79.027724), // Lugar 2
    LatLng(-8.120468, -79.050339), // Lugar 3
    LatLng(-8.119274, -79.036657), // Lugar 4
    LatLng(-8.104353, -79.043062), // Lugar 5
    LatLng(-8.111253, -79.014539), // Lugar 1
    LatLng(-8.075354, -79.031943), // Lugar 2
    LatLng(-7.318152, -78.175699), // Lugar 3
    LatLng(-12.107716, -76.966874), // Lugar 4
    LatLng(-2.898234, -79.007054), // Lugar 5
    LatLng(36.175153, -115.141825), // Lugar 1
  ];

  final listChapters = [
    LatLng(-8.120775, -79.044919), // Lugar 1
    LatLng(-8.119848, -79.043964), // Lugar 2
    LatLng(-8.120125, -79.043572), // Lugar 3
  ];

  final listChapters2 = [
    LatLng(-8.120468, -79.050339), // Lugar 1
    LatLng(-8.120905, -79.047984), // Lugar 2
  ];

  void _addMarkersChapters(int index) {
    print("INDEX: $index");

    setState(() {
      print("AÑADIENDO MARKERS DE LOS CHAPTERS");
      showMarkerChapters = true;
      _markersChapters.clear();
      // TODO CAMBIAR LOGICA PERO ESTA SENCILLO PARA QUE SE AÑADA LOS CHAPTERS DE LOS STORIES
      _markersChapters.addAll(index == 0 ? listChapters : listChapters2);
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
    // final chapters = ref.watch(chapterProvider);

    return SafeArea(
      child: Stack(
        children: [
          // Center(
          //     child: SizedBox(
          //       height: 120,
          //       width: 200,
          //       child: lottie.Lottie.asset(
          //         'assets/lottie/loading_map_general.json',
          //         frameRate: lottie.FrameRate(60), // Ajusta la fluidez.
          //         repeat: true,
          //         animate: true,
          //       ),
          //     ),
          //   )
          // isLoadingMap
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
                    ...nearbyPlaces.asMap().entries.map((entry) {
                      final e = entry.value;
                      final i = entry.key;
                      return Marker(
                        markerId: MarkerId('marker_story_$e'),
                        position: e,
                        icon: customStoryIcon,
                        infoWindow: InfoWindow(title: 'Title ${e.hashCode}'),
                        onTap: () {
                          setState(() {
                            if (!isCardVisible) {
                              toggleCard();
                            }
                            // TODO GUIA PARA MOSTRAR DETALLE DE LA STORY
                            // _selectedPlace = placeInfos[i];
                          });
                          // TODO PARA MOSTRAR EL SWIPER DE STORY O STORIES
                          // _showMarkerStories();

                          // TODO RECORRIDO DESDE EL USUARIO AL INICIO DE LA STORY
                          // initializePolyline(
                          //     latitudeDestination: e.latitude,
                          //     longitudeDestination: e.longitude);

                          // TODO AÑADIR MARKER DE LOS CHAPTERS DE LA STORY
                          _addMarkersChapters(i);
                        },
                      );
                    }),

                    // MARKER DE LOS CHAPTERS DE LA STORY
                    if (showMarkerChapters)
                      ..._markersChapters.skip(1).map((e) => Marker(
                            markerId: MarkerId('marker_chapter_$e'),
                            position: e,
                            icon: customChapterIcon,
                            infoWindow:
                                InfoWindow(title: 'Title ${e.hashCode}'),
                            onTap: () {
                              // setState(() {
                              // if (!isCardVisible) {
                              //   toggleCard();
                              // } else if (!isSwiperVisible) {
                              //   toggleSwiper();
                              // }
                              // _selectedPlace = placeInfos[i];
                              // });
                              // _showMarkerStories();
                              // initializePolyline(
                              //     latitudeDestination: e.latitude,
                              //     longitudeDestination: e.longitude);
                            },
                          )),
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
              padding: const EdgeInsets.only(top: 65),
              child: Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    // height: kToolbarHeight - 10,
                    // width: MediaQuery.of(context).size.width - 20,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _controller,
                            onTap: () {
                              if (isCardVisible) {
                                toggleCard();
                              }
                            },
                            // onChanged: () {},
                            decoration: InputDecoration(
                              hintText: 'Busca por país o ciudad...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                // borderSide: BorderSide(color: Colors.green),
                              ),
                              fillColor:
                                  isDarkmode ? Colors.black : Colors.white,
                              filled: true,
                              // Icono a la derecha
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  if (isCardVisible) {
                                    toggleCard();
                                  }
                                  if (!isSwiperVisible) {
                                    toggleSwiper();
                                  }
                                  // Aquí puedes colocar la lógica para ejecutar cuando el icono sea presionado
                                  print('Buscar: ${_controller.text}');
                                  // Puedes hacer una búsqueda o cualquier otra acción que desees
                                },
                              ),
                            ),

                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkmode ? Colors.white : Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...[...countries, ...cities].map((option) {
                                return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (isCardVisible) {
                                          toggleCard();
                                        }
                                        if (!isSwiperVisible) {
                                          toggleSwiper();
                                        }
                                        print('Opción seleccionada: $option');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkmode
                                            ? Colors.black
                                            : Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 8.0),
                                        shadowColor: Colors
                                            .transparent, // Eliminar sombra
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Opcional, para bordes redondeados
                                        ),
                                      ),
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          color: isDarkmode
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
                    ]),
                  ))),

          // CARD DE LA STORY INDIVIDUAL
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // TODO ESTO PUEDES QUITAR PORQUE CUANDO SCROLEAS Y ESTA ESTO VISIBLE NO SE PUEDE HACER ZOOM ETC EN ESA PARTE. PREUBA BAJANDO EL PADDING , ESTE HEIGHT TU ME ENTIENDES
              height: !isCardVisible ? 0 : 230,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: AnimatedOpacity(
                  opacity: isCardVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 7),
                      child: CardStoryMap(
                        index: 1,
                      )),
                ),
              ),
            ),
          ),

          //     ? Center(
          //         child:
          //             CircularProgressIndicator()) // Muestra cargando
          //     // : chapters.isEmpty
          //     : 1 != 1
          //         ? MessageEmptyChapter()
          //         : isCardVisible
          //             ? FadeInUp(
          //                 duration: Duration(
          //                     milliseconds:
          //                         300), // Duración del fade in
          //                 child: CardStoryMap(
          //                   index: 1,
          //                 ))
          //             : null
          // :
          //
          //
          //
          //

          // SWIPER CARD DE LAS STORIES RESULTADO DE LA BÚSQUEDA
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // TODO ESTO PUEDES QUITAR PORQUE CUANDO SCROLEAS Y ESTA ESTO VISIBLE NO SE PUEDE HACER ZOOM ETC EN ESA PARTE. PREUBA BAJANDO EL PADDING , ESTE HEIGHT TU ME ENTIENDES
              height: !isSwiperVisible ? 0 : 230,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: AnimatedOpacity(
                  opacity: isSwiperVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Swiper(
                    itemCount: 10,
                    index: 1,
                    itemBuilder: (BuildContext context, int index) {
                      // final chapter = chapters[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 7),
                        child: CardStoryMap(
                          index: 1,
                        ),
                      );
                    },
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor:
                            colors.primary, // Color de los puntos activos
                        color: isDarkmode ? Colors.grey[700] : Colors.grey[300],
                        size: 8.0, // Tamaño de los puntos inactivos
                        activeSize: 10.0, // Tamaño de los puntos activos
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

          Positioned(
            bottom: 24,
            left: 12,
            child: Column(
              children: [
                // IconButton(
                //   style: IconButton.styleFrom(
                //     padding: const EdgeInsets.all(10),
                //     shape: const RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //     ),
                //     backgroundColor: isDarkmode ? Colors.black38 : Colors.white,
                //   ),
                //   icon: Icon(
                //     Icons.sync,
                //     color: colors.primary,
                //     size: 32,
                //   ),
                //   onPressed: () {
                //     // refreshLocation();
                //   },
                // ),
                // const SizedBox(height: 10),
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
