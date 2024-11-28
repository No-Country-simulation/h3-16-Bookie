import 'package:bookie/presentation/widgets/cards/stories_read_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoriesReadSection extends StatelessWidget {
  final List<Map<String, dynamic>> readStories;

  const StoriesReadSection({super.key, required this.readStories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Cambié a start para alinearlo a la izquierda
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Historias leidas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: List.generate(
              readStories.length,
              (index) {
                final story = readStories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
// Ajusta el espacio entre cards
                  child: SizedBox(
                    width: 120, // Reduce el ancho del card
                    child: StoriesReadCard(
                      imageUrl: story['imageUrl']!,
                      title: story['title']!,
                      chapter: story['chapter']!,
                      onCardPress: () {
                        // Aquí es donde agregarías la lógica para navegar al card
                        context.push('/story/${story['id']}');
                        // print('Navegando a ${story['title']}');
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
