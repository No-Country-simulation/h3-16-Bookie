import 'package:bookie/presentation/widgets/cards/hero_card.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatefulWidget {
  final List<Map<String, dynamic>> unreadStories;
  const HeroSection({super.key, required this.unreadStories});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 270, // Altura del slider
        child: Swiper(
          itemCount: widget.unreadStories.length,
          itemBuilder: (BuildContext context, int index) {
            final story = widget.unreadStories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: HeroCard(
                id: story['id']!,
                imageUrl: story['imageUrl']!,
                title: story['title']!,
                synopsis: story['synopsis']!,
                rating: story['rating'],
                reads: story['reads'],
                distance: story['distance']!,
                isFavorite: story['isFavorite'],
                onCardPress: () {
                  if (story['id'] == '1') {
                    context.push('/story/274');
                  } else if (story['id'] == '2') {
                    // context.push('/story/2');
                  } else if (story['id'] == '3') {
                    context.push('/home/1');
                  } else if (story['id'] == '4') {
                    context.push('/home/2');
                  }
                },
              ),
            );
          },
          loop: true, // Bucle infinito
          autoplay: true, // Autoplay para el slider
          autoplayDelay: 3000, // Intervalo de autoplay (3 segundos)
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              activeColor: colors.primary, // Color de los puntos activos
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              size: 8.0, // Tamaño de los puntos inactivos
              activeSize: 10.0, // Tamaño de los puntos activos
            ),
          ), // Agrega paginación si lo deseas
          viewportFraction: 0.90, // Cada card ocupa 3/4 del ancho
          // scale:
          //     0.9, // Reduce un poco el tamaño de los cards en el borde para crear un efecto de profundidad
        ),
      ),
    );
  }
}
