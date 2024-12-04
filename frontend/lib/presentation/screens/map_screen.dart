import 'dart:async';

import 'package:bookie/config/geolocator/geolocator.dart';
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

  // final Set<Marker> _markers = {};
  late Future<bool> isUnlockedFuture;
  bool isLoading = true;
  bool isLoadingMap = true;
  late double latitudeUser;
  late double longitudeUser;
  final String title = "title";
  late StreamSubscription<Position> positionStream;
  bool isCardVisible = false;

  void toggleCard() {
    setState(() {
      isCardVisible = !isCardVisible;
    });
  }

// TODO REVISAR SI MEJOR CARGAR LOS ICONOS DEL MAPA DE FORMA ASINCRONA
//   Future<void> customMarkerStories() async {
//    customStoryIcon = await BitmapDescriptor.fromAssetImage(
//      const ImageConfiguration(size: Size(65, 65)),
//      'assets/images/marker_story_noread.webp',
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

      setState(() {
        latitudeUser = userPosition.latitude;
        longitudeUser = userPosition.longitude;
      });
    } catch (e) {
      print('Error al determinar la posición: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al determinar la posición')),
      );
    } finally {
      setState(() {
        isLoadingMap = false;
      });
    }
  }

  void customMarkerStories() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(65, 65)),
            'assets/images/marker_story_noread.webp')
        .then(
      (value) {
        // setState(() {
        customStoryIcon = value;
        // });
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

  // for (int i = 0; i < nearbyPlaces.length; i++) {
  // _markers.add(
  //   Marker(
  //     markerId: MarkerId('marker_$i'),
  //     icon: customStoryIcon,
  //     position: nearbyPlaces[i],
  //     infoWindow: InfoWindow(title: 'Title ${i + 1}', snippet: "Story"),
  //     onTap: () {
  //       setState(() {
  //         // TODO GUIA PARA MOSTRAR
  //         // _selectedPlace = placeInfos[i];
  //       });
  //       // TODO PARA MOSTRAR EL SWIPER DE STORY O STORIES
  //       // _showMarkerStories();
  //     },
  //   ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    customMarkerUser();
    customMarkerStories();
    locationUser();
    // _addNearbyMarkers();
    _loadChapters();
    startTrackingUser();
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
    // final chapters = ref.watch(chapterProvider);

    return SafeArea(
      child: Stack(
        children: [
          isLoadingMap
              ? Center(child: SpinKitFadingCircle(color: colors.primary))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitudeUser,
                        longitudeUser), // Posición inicial del mapa
                    zoom: 17,
                    tilt: 50,
                    bearing: 0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  }, // Selecciona el tipo de mapa
                  onTap: (_) {
                    if (isCardVisible) {
                      toggleCard();
                    }
                  },
                  zoomControlsEnabled: true, // Activa los botones de zoom
                  myLocationButtonEnabled: true, // Activa el botón de ubicación
                  mapToolbarEnabled:
                      true, // Habilita la barra de herramientas de Google Maps
                  // myLocationEnabled:
                  //     true, // Muestra la ubicación actual - circulo azul
                  style: isDarkmode ? mapOptionDark : "",
                  markers: {
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
                    // ...Set.from(_markers),
                    ...nearbyPlaces.map((e) => Marker(
                          markerId: MarkerId('marker_$e'),
                          position: e,
                          icon: customStoryIcon,
                          infoWindow: InfoWindow(
                              title: 'Title ${e.hashCode}', snippet: "Story"),
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

                            // TODO AÑADIR MARKER DE LOS CHAPTERS DE LA STORY
                          },
                        ))
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
                  width: 210,
                  child: AppBar(
                    title: Text(
                      // 'Capítulo ${widget.currentChapter}',
                      'Mapa General',
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

          // autcompletado
          // Padding(
          //     padding: const EdgeInsets.only(top: 65, left: 16, right: 16),
          //     child: Container(
          //       alignment: Alignment.topCenter,
          //       child: SizedBox(
          //         height: kToolbarHeight - 10,
          //         // child: Row(children: [
          //         child: TextField(
          //           controller: _controller,
          //           onTap: () {
          //             if (isCardVisible) {
          //               toggleCard();
          //             }
          //           },
          // onChanged: () {},
          //   decoration: InputDecoration(
          //     hintText: 'Busca por titulo, país o ciudad...',
          //     hintStyle: TextStyle(color: Colors.grey.shade500),
          //     // prefixIcon: Icon(Icons.search),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     fillColor: isDarkmode ? Colors.black54 : Colors.white,
          //     filled: true,
          //   ),
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: isDarkmode ? Colors.white : Colors.black,
          //   ),
          //   textAlignVertical: TextAlignVertical.center,
          // ),
          // const SizedBox(width: 8),
          // IconButton(
          //   icon: Icon(
          //     Icons.clear,
          //     color: isDarkmode ? Colors.white : Colors.black,
          //     size: 24,
          //   ),
          //   onPressed: () {},
          // ),
          // ]
          //   ),
          // )),

          // CARD DE LA STORY INDIVIDUAL
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // TODO ESTO PUEDES QUITAR PORQUE CUANDO SCROLEAS Y ESTA ESTO VISIBLE NO SE PUEDE HACER ZOOM ETC EN ESA PARTE. PREUBA BAJANDO EL PADDING , ESTE HEIGHT TU ME ENTIENDES
              height: !isCardVisible ? 0 : 370,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 90, horizontal: 10),
                child: AnimatedOpacity(
                  opacity: isCardVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 25),
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

          // CARD DE LAS STORIES RESULTADO DE LA BÚSQUEDA

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              // TODO ESTO PUEDES QUITAR PORQUE CUANDO SCROLEAS Y ESTA ESTO VISIBLE NO SE PUEDE HACER ZOOM ETC EN ESA PARTE. PREUBA BAJANDO EL PADDING , ESTE HEIGHT TU ME ENTIENDES
              height: !isCardVisible ? 0 : 370,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 90, horizontal: 10),
                child: AnimatedOpacity(
                  opacity: isCardVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Swiper(
                    itemCount: 10,
                    index: 1,
                    itemBuilder: (BuildContext context, int index) {
                      // final chapter = chapters[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 25),
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
                    backgroundColor: isDarkmode ? Colors.black38 : Colors.white,
                  ),
                  icon: Icon(
                    Icons.my_location,
                    color: colors.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    // Función para centrar en la ubicación actual
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(latitudeUser,
                            longitudeUser), // Centrar en la ubicación actual
                      ),
                    );
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
