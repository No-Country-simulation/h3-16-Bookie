import 'package:bookie/config/helpers/get_image_final.dart';
import 'package:bookie/presentation/providers/favorite_provider.dart';
import 'package:bookie/presentation/widgets/cards/favorite_card.dart';
import 'package:bookie/presentation/widgets/shared/show_not_favorites.dart';
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
  // Variable para controlar si las tarjetas ya han sido animadas
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Limpiar los AnimationController para evitar pérdidas de memoria
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider);
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favorites.isEmpty
          ? ShowNotFavorites()
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: MasonryGridView.count(
                crossAxisCount: 3, // Tres columnas
                mainAxisSpacing: 6.0, // Espaciado vertical
                crossAxisSpacing: 6.0, // Espaciado horizontal
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final card = favorites[index];
                  final column = index % 3; // Determina la columna (0, 1 o 2)

                  // Crear un AnimationController si no existe
                  if (_controllers.length <= index) {
                    _controllers.add(AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1000),
                    ));
                  }

                  final controller = _controllers[index];

                  // Inicia la animación
                  controller.forward();

                  // Configurar el efecto basado en la columna
                  Offset beginOffset;
                  switch (column) {
                    case 0: // Columna 1 empieza en la mitad de la tarjeta hacia abajo
                      beginOffset = const Offset(0, -0.5); // Comienza más abajo
                      break;
                    case 1: // Columna 2 empieza en la mitad hacia arriba
                      beginOffset = const Offset(0, 0.5); // Comienza más arriba
                      break;
                    case 2: // Columna 3 empieza en la mitad de la tarjeta hacia abajo
                      beginOffset = const Offset(0, -0.5); // Comienza más abajo
                      break;
                    default:
                      beginOffset = const Offset(0, 0); // Por si acaso
                  }

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin:
                              beginOffset, // Comienza desde la posición configurada
                          end: const Offset(
                              0, 0), // Termina en su posición original
                        ).animate(CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOut,
                        )),
                        child: child,
                      );
                    },
                    child: FavoriteCard(
                      id: card.story.id,
                      imageUrl: getImageUrl(
                          isDarkmode, card.story.img ?? "sin-imagen"),
                      title: card.story.title,
                      quantityChapters: card.story.quantityChapters,
                      onCardPress: () {
                        context.push('/story/${card.story.id}');
                      },
                      isFavorite: favorites
                          .any((element) => element.story.id == card.story.id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
