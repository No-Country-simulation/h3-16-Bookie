import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String synopsis;
  final int lenChapters;

  const StoryCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.synopsis,
      required this.lenChapters});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF292929),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12), // Padding interno del card
        child: Row(
          children: [
            // Primera parte: Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 120,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12), // Espaciado entre la imagen y la columna
            // Segunda parte: Título, sinopsis y capítulos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    synopsis,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 16, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        "$lenChapters capítulos",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
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
