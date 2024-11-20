import 'package:bookie/presentation/widgets/cards/history_close_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HistoryCloseSection extends StatelessWidget {
  final List<Map<String, dynamic>> unreadStories;

  const HistoryCloseSection({super.key, required this.unreadStories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
      children: [
        // Título "Más historias"
        Padding(
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
          child: Row(
            children: List.generate(
              unreadStories.length,
              (index) {
                final story = unreadStories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200, // Ajusta el tamaño del card
                    child: HistoryCloseCard(
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
