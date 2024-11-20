import 'package:bookie/presentation/widgets/cards/unread.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatelessWidget {
  final List<Map<String, dynamic>> unreadStories;
  const HeroSection({super.key, required this.unreadStories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 260, // Altura del slider
          child: Swiper(
            itemCount: unreadStories.length,
            itemBuilder: (BuildContext context, int index) {
              final story = unreadStories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: UnreadCard(
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
              );
            },
            loop: true, // Bucle infinito
            autoplay: true, // Autoplay para el slider
            autoplayDelay: 3000, // Intervalo de autoplay (3 segundos)
            pagination: SwiperPagination(), // Agrega paginación si lo deseas
            viewportFraction: 0.75, // Cada card ocupa 3/4 del ancho
            scale:
                0.9, // Reduce un poco el tamaño de los cards en el borde para crear un efecto de profundidad
          ),
        );
  }
}
