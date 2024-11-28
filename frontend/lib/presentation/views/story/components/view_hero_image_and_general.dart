import 'package:bookie/config/helpers/capitalize.dart';
import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryHeroImageAndGeneral extends ConsumerStatefulWidget {
  final int storyId;
  final String imageUrl;
  final String title;
  final int lenChapters;
  final bool isFavorite;

  const StoryHeroImageAndGeneral({
    super.key,
    required this.isFavorite,
    required this.storyId,
    required this.imageUrl,
    required this.title,
    required this.lenChapters,
  });

  @override
  ConsumerState<StoryHeroImageAndGeneral> createState() =>
      _StoryHeroImageAndGeneralState();
}

class _StoryHeroImageAndGeneralState
    extends ConsumerState<StoryHeroImageAndGeneral> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFavorite =
        ref.watch(favoriteProvider)[widget.storyId] ?? widget.isFavorite;

    return Center(
      child: Column(children: [
        Stack(children: [
          // Imagen con Hero
          Hero(
            tag: 'hero-image-${widget.storyId}',
            child: ClipRRect(
              child: Image.network(
                widget.imageUrl,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botón de favorito
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                // Lógica de agregar/quitar de favoritos
                ref
                    .read(favoriteProvider.notifier)
                    .toggleFavorite(widget.storyId);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.6), // Fondo oscuro semitransparente
                  shape: BoxShape.circle, // Forma circular
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 2), // Sombras
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ]),
        SizedBox(height: 8),
        Text(
          capitalize(widget.title),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: colors.primary),
        ),
        SizedBox(height: 8),
        Text("Autor: Ana Sofia"),
        SizedBox(height: 8),
        // cambiar icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ubicación e icono
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Bogota, a 2 km",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Capítulos e icono
            Row(
              children: [
                const Icon(Icons.book, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "${widget.lenChapters} capítulos",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            // Tiempo e icono
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                const Text(
                  "30 min",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        // Text(
        //   "Lugar: Museo del Oro Bogotá\nCra. 6 #15-88, Bogotá, Colombia",
        //   style: TextStyle(fontSize: 12),
        // ),
      ]),
    );
  }
}
