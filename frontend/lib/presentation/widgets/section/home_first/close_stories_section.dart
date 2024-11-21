import 'package:bookie/presentation/widgets/cards/close_stories_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseStoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> unreadStories;

  const CloseStoriesSection({super.key, required this.unreadStories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
      children: [
        // Título "Más historias"
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Historias cercanas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        // Sección de "Más historias" con Scroll Horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: List.generate(
              unreadStories.length,
              (index) {
                final story = unreadStories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SizedBox(
                    width: 150, // Ajusta el tamaño del card
                    child: CloseStoriesCard(
                      id: story['id']!,
                      imageUrl: story['imageUrl']!,
                      title: story['title']!,
                      synopsis: story['synopsis']!,
                      rating: story['rating'],
                      reads: story['reads'],
                      distance: story['distance']!,
                      isFavorite: story['isFavorite'],
                      onCardPress: () {
                        context.go('/history/${story['id']}');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
