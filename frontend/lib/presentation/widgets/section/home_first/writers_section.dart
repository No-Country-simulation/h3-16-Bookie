import 'package:bookie/presentation/widgets/cards/writer_card.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WritersSection extends StatelessWidget {
  final List<Map<String, dynamic>> writers;
  const WritersSection({super.key, required this.writers});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Título "Escritores"
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Escritores",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          // Tamaño del slider
          height: 130, // Altura del slider
          child: Swiper(
            itemCount: writers.length,
            itemBuilder: (BuildContext context, int index) {
              final writer = writers[index];
              return WriterCard(
                id: writer['id'],
                imageUrl: writer['imageUrl'],
                name: writer['name'],
                onCardPress: () {
                  context.go('/writer/${writer['id']}');
                },
              );
            },
            loop: true, // Bucle infinito
            autoplay: true, // Autoplay para el slider
            autoplayDelay: 3000, // Intervalo de autoplay (3 segundos)
            // pagination: SwiperPagination(), // Agrega paginación si lo deseas
            viewportFraction: 0.25, // Cada card ocupa 3/4 del ancho
            // scale:
            //     0.9, // Reduce un poco el tamaño de los cards en el borde para crear un efecto de profundidad
          ),
        ),
      ],
    );
  }
}
