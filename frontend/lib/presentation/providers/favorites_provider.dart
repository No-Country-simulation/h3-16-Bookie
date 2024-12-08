import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/presentation/providers/stories_all_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProviderOld =
    StateNotifierProvider<FavoriteNotifierOld, Map<int, bool>>((ref) {
  final stories = ref.watch(storiesAllProvider);

  return FavoriteNotifierOld(stories: stories);
});

class FavoriteNotifierOld extends StateNotifier<Map<int, bool>> {
  final List<Story> stories;

  FavoriteNotifierOld({required this.stories}) : super({}) {
    getFavorites();
  }

  // Método para obtener todos los favoritos
  void getFavorites() {
    state = stories.fold<Map<int, bool>>({}, (map, story) {
      map[story.id] = false;
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
