import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/presentation/providers/read_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ChapterCard extends ConsumerStatefulWidget {
  final int index;
  final String title;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int storyId;
  final int chapterId;

  const ChapterCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.storyId,
    required this.chapterId,
  });

  @override
  ConsumerState<ChapterCard> createState() => _ChapterCardState();
}

class _ChapterCardState extends ConsumerState<ChapterCard> {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Esquinas redondeadas
      ),
      child: InkWell(
        onTap: () async {
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
                // añadiendo a leido el capitulo
                ref
                    .read(readProvider.notifier)
                    .completeReaderChapter(widget.storyId, widget.chapterId);

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

                      const SizedBox(height: 4.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
