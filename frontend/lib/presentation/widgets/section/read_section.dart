import 'package:bookie/presentation/widgets/cards/read.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReadSection extends StatelessWidget {
  final List<Map<String, dynamic>> readStories;

  const ReadSection({super.key, required this.readStories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Cambié a start para alinearlo a la izquierda
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Leidos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              readStories.length,
              (index) {
                final story = readStories[index];
                return Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Ajusta el espacio entre cards
                  child: SizedBox(
                    width: 160, // Reduce el ancho del card
                    child: ReadCard(
                      imageUrl: story['imageUrl']!,
                      title: story['title']!,
                      chapter: story['chapter']!,
                      onCardPress: () {
                        // Aquí es donde agregarías la lógica para navegar al card
                        context.go('/history/${story['id']}');
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
