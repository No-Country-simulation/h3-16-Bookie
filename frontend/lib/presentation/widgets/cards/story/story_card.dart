import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String synopsis;
  final int lenChapters;
  final int storyId;

  const StoryCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.synopsis,
      required this.lenChapters,
      required this.storyId});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final imageMod = getImageUrl(isDarkmode, imageUrl);
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkmode ? Colors.black : Colors.white,
      elevation: 4,
      child: InkWell(
        onTap: () {
          context.push('/story/edit/$storyId');
        },
        splashColor: colors.primary.withAlpha(30), // Color de la onda
        highlightColor: colors.primary.withAlpha(50),

        child: Padding(
          padding: const EdgeInsets.all(12), // Padding interno del card
          child: Row(
            children: [
              // Primera parte: Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageMod,
                  height: 120,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                  width: 12), // Espaciado entre la imagen y la columna
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
                          "$lenChapters ${getChaptersLabel(lenChapters)}",
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
      ),
    );
  }
}
