import 'package:bookie/presentation/providers/favorites_provider.dart';
import 'package:bookie/presentation/widgets/cards/history_close_card.dart';
import 'package:bookie/shared/data/histories.dart';
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
    // Filtra las tarjetas que son favoritas
    final favoriteCards = unreadStories
        .where((card) => ref.watch(favoriteProvider)[card['id']] ?? false)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteCards.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : MasonryGridView.count(
              crossAxisCount: 3, // Tres columnas
              mainAxisSpacing: 12.0, // Espaciado vertical
              crossAxisSpacing: 12.0, // Espaciado horizontal
              itemCount: favoriteCards.length,
              itemBuilder: (context, index) {
                final card = favoriteCards[index];

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
                    child: HistoryCloseCard(
                      id: card['id'] as String,
                      imageUrl: card['imageUrl'] as String,
                      title: card['title'] as String,
                      isFavorite: card['isFavorite'] as bool,
                      onCardPress: () {
                        context.go('/history/${card['id']}');
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
