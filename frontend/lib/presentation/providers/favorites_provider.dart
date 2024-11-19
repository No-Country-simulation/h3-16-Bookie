import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<Map<String, bool>> {
  FavoriteNotifier() : super({});

  // Método para alternar el estado de favorito por id
  void toggleFavorite(String id) {
    state = {
      ...state,
      id: !(state[id] ?? false), // Cambia el estado del favorito usando el id
    };
  }
}

// Definir el provider de favoritos
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, bool>>((ref) {
  return FavoriteNotifier();
});
