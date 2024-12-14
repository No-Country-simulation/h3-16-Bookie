import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/config/helpers/word_plural.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardStoryMap extends StatelessWidget {
  final Story story;

  const CardStoryMap({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final imageMod = getImageUrl(isDarkmode, story.imageUrl);

    return InkWell(
      onTap: () {
        // Acción al pulsar el card
        context.push('/story-only/${story.id}');
      },
      splashColor: colors.primary.withAlpha(30),
      highlightColor: colors.primary.withAlpha(50),
      child: Card(
        color: isDarkmode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
            width: double.infinity, // Ancho del card
            height: 160, // Alto del card
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Imagen que ocupa 1/4 del card
                      Container(
                        width: 75, // 1/4 del tamaño total
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              imageMod,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // ListTile para el título y subtítulo
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                story.title,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${story.chapters.length} ${getChaptersLabel(story.chapters.length)}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Icono de bloqueo o desbloqueo en la esquina superior derecha
                ],
              ),
            )),
      ),
    );
  }
}
