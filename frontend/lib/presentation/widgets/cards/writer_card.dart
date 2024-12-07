import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/short_name.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WriterCard extends StatefulWidget {
  final int id; // ID único
  final String name;
  final String imageUrl;
  final VoidCallback onCardPress;

  const WriterCard({
    super.key,
    required this.id, // Requiere un id único
    required this.name,
    required this.imageUrl,
    required this.onCardPress,
  });

  @override
  State<WriterCard> createState() => _WriterCardState();
}

class _WriterCardState extends State<WriterCard> {
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
    final imageMod = getImageUrl(isDarkmode, widget.imageUrl);

    return GestureDetector(
      onTap: widget.onCardPress, // Acción al presionar el card
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del card con Shimmer (loader)
            isLoading
                ? Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        color: containerShimmer,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      image: DecorationImage(
                        image: NetworkImage(imageMod),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            // Título y capítulo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
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
                          shortenName(widget.name),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
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
