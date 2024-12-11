import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/short_name.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoriesReadCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int indexChapter;
  final VoidCallback onCardPress;
  final bool isCompleteStory;

  const StoriesReadCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.indexChapter,
    required this.onCardPress,
    required this.isCompleteStory,
  });

  @override
  State<StoriesReadCard> createState() => _StoriesReadCardState();
}

class _StoriesReadCardState extends State<StoriesReadCard> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // Método para cargar la imagen y detectar cuando termina de cargar
  void _loadImage() {
    final imageMod = getImageUrl(true, widget.imageUrl);
    final image = NetworkImage(imageMod);
    image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) {
              // Cuando la imagen se haya cargado completamente, cambia el estado
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onError: (exception, stackTrace) {
              // Si ocurre un error al cargar la imagen
              if (mounted) {
                setState(() {
                  isLoading =
                      false; // También puedes manejar un estado de error aquí si lo deseas
                });
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // muchos repites este codigo revisar como factorizarlo mas adelante
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;

    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: widget.onCardPress, // Acción al presionar el card
      focusColor: Colors.transparent,
      splashColor: colors.primary.withOpacity(0.3),
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Colors.transparent),
      ),
      child: Card(
        color: containerShimmer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del card con Shimmer (loader)
            isLoading
                ? Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        color: containerShimmer,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            // Título y capítulo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 150,
                              height: 20,
                              color: containerShimmer,
                            ),
                          ),
                        )
                      : Text(
                          capitalizeFirstWord(shortenName2(widget.title)),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: colors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                  SizedBox(height: 1),
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              height: 14,
                              color: containerShimmer,
                            ),
                          ),
                        )
                      : Text(
                          "Capítulo ${widget.indexChapter + 1}",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                  SizedBox(height: 1),
                  Text(
                    widget.isCompleteStory ? "Completado" : "Continuar",
                    style: TextStyle(
                      color: colors.primary.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
