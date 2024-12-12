import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/presentation/providers/read_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class CardChapterMap extends ConsumerStatefulWidget {
  final String title;
  final int index;
  final double latitude;
  final double longitude;
  final int storyId;
  final String imageUrl;
  final int chapterId;

  const CardChapterMap({
    super.key,
    required this.title,
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.storyId,
    required this.imageUrl,
    required this.chapterId,
  });

  @override
  ConsumerState<CardChapterMap> createState() => CardChapterMapState();
}

class CardChapterMapState extends ConsumerState<CardChapterMap> {
  late Future<bool> isBlocked;
  bool enableGoToMapOrChapter = false;
  bool isReadMessage = false;

  @override
  void initState() {
    super.initState();
    calculateBlockedStatus();
  }

  Future<bool> isBlockedFuture(
    double latitude,
    double longitude,
  ) async {
    try {
      final isRead = ref
          .read(readProvider.notifier)
          .isRead(widget.storyId, widget.chapterId);

      if (isRead) {
        setState(() {
          isReadMessage = true;
        });
        return false;
      }

      final isAfter = ref
          .read(readProvider.notifier)
          .isAfterBlocked(widget.storyId, widget.chapterId);

      if (isAfter) {
        return true;
      }

      final userPosition = await determinePosition();

      final isLocked = isWithinRadius(
        userPosition,
        latitude,
        longitude,
      );

      return isLocked;
    } catch (e) {
      return true;
    }
  }

  void calculateBlockedStatus() {
    setState(() {
      enableGoToMapOrChapter = false;
    });
    if (mounted) {
      setState(() {
        isBlocked = isBlockedFuture(widget.latitude, widget.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkmode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          if (enableGoToMapOrChapter) {
            // Acción para navegar a la historia
            // context
            isBlocked.then((value) {
              if (!value) {
                ref
                    .read(readProvider.notifier)
                    .completeReaderChapter(widget.storyId, widget.chapterId);
                // es decir si esta desbloqueado
                context
                    .push('/chapters/view/${widget.storyId}/${widget.index}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text("Tienes que estar cerca para ver el capítulo"),
                    duration: Duration(seconds: 1),
                    backgroundColor: colors.primary,
                  ),
                );
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
        splashColor: colors.primary.withAlpha(30),
        highlightColor: colors.primary.withAlpha(50),
        child: SizedBox(
          width: double.infinity,
          height: 160,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            getImageUrl(isDarkmode, widget.imageUrl),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: -0,
                  right: -0,
                  child: FutureBuilder<bool>(
                    future: isBlocked,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SpinKitFadingCircle(
                          color: Colors.grey,
                          size: 20.0,
                        );
                      } else if (snapshot.hasError) {
                        return const SizedBox();
                      } else {
                        final isBlockedValue = snapshot.data ?? false;

                        isBlocked.then((value) {
                          if (mounted) {
                            // Verifica si el widget sigue montado
                            setState(() {
                              enableGoToMapOrChapter = true;
                            });
                          }
                        });

                        return Icon(
                          isBlockedValue ? Icons.lock : Icons.lock_open,
                          color: isBlockedValue ? Colors.red : Colors.green,
                          size: 20,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: -14,
                  right: -12,
                  child: Row(
                    children: [
                      if (isReadMessage)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0.5),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(
                                0.1), // Color de fondo con opacidad
                            borderRadius:
                                BorderRadius.circular(12), // Bordes redondeados
                            border: Border.all(
                                color:
                                    colors.primary), // Borde con color primario
                          ),
                          child: Text(
                            "Leído",
                            style: TextStyle(
                              color: colors.primary, // Color del texto
                              fontSize: 12,
                              fontWeight: FontWeight
                                  .bold, // Opcional: estilo más destacado
                            ),
                          ),
                        ),
                      IconButton(
                        style: IconButton.styleFrom(
                          // shape: null,
                          // const RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(10)),
                          // ),
                          backgroundColor: Colors.transparent,
                          // isDarkmode ? Colors.black38 : Colors.white,
                        ),
                        icon: Icon(
                          Icons.sync,
                          color: colors.primary,
                          size: 18,
                        ),
                        onPressed: () {
                          calculateBlockedStatus(); // Llamada para refrescar el estado
                        },
                        splashColor:
                            Colors.transparent, // Elimina el efecto splash
                        highlightColor:
                            Colors.transparent, // Elimina el efecto highlight
                        enableFeedback: false, // Desactiva el feedback háptico
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
