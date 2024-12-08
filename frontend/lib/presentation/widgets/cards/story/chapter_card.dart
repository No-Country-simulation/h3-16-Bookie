import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/get_distance_minime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ChapterCard extends StatefulWidget {
  final int index;
  final String title;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int storyId;

  const ChapterCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.storyId,
  });

  @override
  State<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends State<ChapterCard> {
  late final Future<bool> isBlocked;
  bool enableGoToMapOrChapter = false;
  bool? showMessageGoToMapOrChapter;

  @override
  void initState() {
    super.initState();
    isBlocked = isBlockedFuture(
      widget.latitude,
      widget.longitude,
    );
  }

// TODO VER SI INCORPORAR SINO YA FUE
  // void refreshLocation() {
  //   setState(() {
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> getLocation() async {
  //   return await getCountryAndProvinceAndDistance(
  //     widget.latitude,
  //     widget.longitude,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Color de fondo oscuro y ajustes para el diseño
    // final lockIcon = isUnlocked ? Icons.lock_open : Icons.lock;
    // final iconColor = isUnlocked ? Colors.green : Colors.red;

    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Esquinas redondeadas
      ),
      child: InkWell(
        onTap: () {
          if (enableGoToMapOrChapter) {
            // Acción para navegar a la historia
            // context
            isBlocked.then((value) {
              if (value) {
                context.push(
                    '/chapters/view/${widget.storyId}/${widget.index}/map',
                    extra: {
                      'latitude': widget.latitude,
                      'longitude': widget.longitude,
                      'currentChapter': widget.index,
                      // 'title': widget.title,
                      'storyId': widget.storyId,
                    });
              } else {
                context
                    .push('/chapters/view/${widget.storyId}/${widget.index}');
              }
            });
          } else {
            // Mostrar Tooltip si no está habilitado aún
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Espera un momento, estamos calculando la ubicación..."),
                duration: Duration(seconds: 1),
                backgroundColor: colors.primary,
              ),
            );
          }
        },
        splashColor: colors.primary.withAlpha(30), // Color de la onda
        highlightColor: colors.primary.withAlpha(50),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espacio entre los elementos
            children: [
              // Parte izquierda: Imagen con mayor peso y altura
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.imageUrl,
                  width: 80, // Aumentamos el ancho de la imagen
                  height: 80, // Aumentamos la altura de la imagen
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 4.0), // Espacio entre el imagen y el texto

              // Parte derecha: Información del capítulo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Capítulo número y estado (bloqueado/desbloqueado)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Capítulo ${widget.index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder<bool>(
                            future: isBlocked,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SpinKitFadingCircle(
                                  color: Colors.grey,
                                  size: 25.0,
                                );
                              } else if (snapshot.hasError) {
                                return const SizedBox(); // Devolvemos un widget vacío en caso de error
                              } else {
                                final isBlockedValue = snapshot.data ?? false;

                                // Usamos addPostFrameCallback para asegurarnos de que setState no se llame mientras el widget está construyendo
                                isBlocked.then((value) {
                                  if (mounted) {
                                    // Verifica si el widget sigue montado
                                    setState(() {
                                      enableGoToMapOrChapter = true;
                                      showMessageGoToMapOrChapter = value;
                                    });
                                  }
                                });

                                return Icon(
                                  isBlockedValue ? Icons.lock : Icons.lock_open,
                                  color: isBlockedValue
                                      ? Colors.red
                                      : Colors.green,
                                  size: 24,
                                );
                              }
                            },
                          )
                        ],
                      ),

                      // Título del capítulo
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),

                      // Distancia
                      // afecta el redimiento ESTO LO CAMBIAMOS DESPUES ES FACIL CALCULAR LA DISTANCIA DESDE EL USUARIO AL CAPÍTULO
                      const SizedBox(height: 4.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(children: [
                            //   Icon(Icons.route,
                            //       size: 16, color: colors.primary),
                            //   const SizedBox(width: 4),
                            //   FutureBuilder(
                            //     future: getLocation(),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasData) {
                            //         return Text(
                            //           snapshot.data ?? "10 m",
                            //           style: TextStyle(
                            //             fontSize: 12.0,
                            //           ),
                            //         );
                            //       } else {
                            //         return Text(
                            //           "10 m",
                            //           style: TextStyle(
                            //             fontSize: 12.0,
                            //           ),
                            //         );
                            //       }
                            //     },
                            //   ),
                            //   // const Text(
                            //   //   "A 10 m",
                            //   //   style: TextStyle(
                            //   //     fontSize: 12.0,
                            //   //   ),
                            //   // ),
                            // ]),
                            Text(
                              showMessageGoToMapOrChapter != null
                                  ? showMessageGoToMapOrChapter == true
                                      ? "Ver Mapa"
                                      : "Ver Capítulo"
                                  : "",
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
