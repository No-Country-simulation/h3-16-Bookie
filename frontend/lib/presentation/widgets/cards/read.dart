import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReadCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String chapter;
  final VoidCallback onCardPress;

  const ReadCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.chapter,
    required this.onCardPress,
  });

  @override
  State<ReadCard> createState() => _ReadCardState();
}

class _ReadCardState extends State<ReadCard> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // Método para cargar la imagen y detectar cuando termina de cargar
  void _loadImage() {
    final image = NetworkImage(widget.imageUrl);
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
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: widget.onCardPress, // Acción al presionar el card
      splashColor:
          colors.primary.withOpacity(0.3), // Color de la onda al presionar
      highlightColor:
          colors.primary.withOpacity(0.1), // Color de la onda al presionar
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del card con Shimmer (loader)
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 150,
                            height: 20,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                  SizedBox(height: 2),
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.chapter,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                  SizedBox(height: 2),
                  isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Continuar",
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 14,
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
