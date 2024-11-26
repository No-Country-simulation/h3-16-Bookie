import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:bookie/presentation/widgets/cards/close_stories_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  static const String name = 'favorites';

  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);
    final stories = ref.watch(getStoriesProvider);

    // Filtra las tarjetas que son favoritas
    final favoriteStories =
        stories.where((story) => favorites[story.id] ?? false).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteStories.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : MasonryGridView.count(
              crossAxisCount: 3, // Tres columnas
              mainAxisSpacing: 12.0, // Espaciado vertical
              crossAxisSpacing: 12.0, // Espaciado horizontal
              itemCount: favoriteStories.length,
              itemBuilder: (context, index) {
                final card = favoriteStories[index];

                // Aplica un efecto de entrada animado al card
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration:
                      Duration(milliseconds: 500), // Duración de la animación
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, -1), // Inicia arriba de la pantalla
                      end: Offset(0, 0), // Se mueve a su lugar
                    ).animate(CurvedAnimation(
                      parent: AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 500),
                      )..forward(), // Inicia la animación
                      curve: Curves.easeOut,
                    )),
                    child: CloseStoriesCard(
                      id: card.id,
                      imageUrl: card.imageUrl,
                      title: card.title,
                      isFavorite: card.isFavorite,
                      distance: card.distance,
                      onCardPress: () {
                        context.go('/history/${card.id}');
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
