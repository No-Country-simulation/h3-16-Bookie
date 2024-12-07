import 'package:bookie/config/intl/i18n.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/widgets/cards/close_stories_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseStoriesSection extends StatelessWidget {
  final List<Story> stories;
  final AppLocalizations? localizations;

  const CloseStoriesSection(
      {super.key, required this.stories, this.localizations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Historias cercanas"
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              localizations?.translate("homepage_close_stories") != null
                  ? "${localizations?.translate("homepage_close_stories")}"
                  : "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 8),

          // todo: esto cambiara, creo q no usar Future Builder sino como estaba antes no se hara de esta manera porque se traera de una api
          // Sección de "Más historias" con Scroll Horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(
                stories.length,
                (index) {
                  final story = stories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: SizedBox(
                      width: 150, // Ajusta el tamaño del card
                      child: CloseStoriesCard(
                        id: story.id,
                        imageUrl: story.imageUrl,
                        title: story.title,
                        // synopsis: story.synopsis,
                        // rating: story['rating'],
                        // reads: story['reads'],
                        distance: story.distance,
                        // TODO: ESTO SE VA POSIBLEMENTE SE QUITE PORQUE SE TRAERA O SE REALIZARA DE OTRA MANERA PARA TRAERSE LOS FAVORITOS, POR AHORA ES SOLO PARA SIMULAR
                        isFavorite: false, // TODO FAVORITOS
                        onCardPress: () {
                          context.push('/story/${story.id}');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
