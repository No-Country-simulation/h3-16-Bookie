import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definir el provider de favoritos
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<int, bool>>((ref) {
  final stories = ref.watch(getStoriesProvider);

  return FavoriteNotifier(stories: stories);
});

class FavoriteNotifier extends StateNotifier<Map<int, bool>> {
  final List<Story> stories;

  FavoriteNotifier({required this.stories}) : super({}) {
    getFavorites();
  }

  // Método para obtener todos los favoritos
  void getFavorites() {
    state = stories.fold<Map<int, bool>>({}, (map, story) {
      map[story.id] = story.isFavorite;
      return map;
    });
  }

  // Método para alternar el estado de favorito por id
  void toggleFavorite(int id) {
    state = {
      ...state,
      id: !(state[id] ?? false), // Cambia el estado del favorito usando el id
    };
  }
}
