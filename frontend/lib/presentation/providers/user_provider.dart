import 'package:bookie/domain/entities/user_entity.dart';
import 'package:bookie/infrastructure/datasources/userdb_datasource.dart';
import 'package:bookie/infrastructure/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepositoryImpl(UserDbDatasource());
});

// estado global de las users
final usersProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return UserNotifier(
    getWriters: repository.getWriters,
  );
});

class UserNotifier extends StateNotifier<List<User>> {
  final Future<List<User>> Function() getWriters;
  bool _isLoaded = false; // Bandera para saber si los escritores ya se cargaron

  UserNotifier({
    required this.getWriters,
  }) : super([]);

  Future<void> loadWriters() async {
    if (_isLoaded) return; // Si los datos ya fueron cargados, no recargar

    try {
      final List<User> writers = await getWriters();

      state = writers;
      _isLoaded = true; // Marcar como cargado
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reloadWriters() async {
    // Método para resetear la bandera y recargar los datos si es necesario
    _isLoaded = false;
    final List<User> writers = await getWriters();
    state = writers;
    _isLoaded = true;
  }

  void setIsLoaded() {
    _isLoaded = false;
  }
}
