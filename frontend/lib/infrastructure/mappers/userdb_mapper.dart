import 'package:bookie/domain/entities/user_entity.dart';
import 'package:bookie/infrastructure/models/user_db.dart';

class UserMapper {
  static User userDbToEntity(UserDb userDbResponse) {
    final String name = userDbResponse.name.contains('@')
        ? userDbResponse.name.split('@').first // Toma la parte antes del '@'
        : userDbResponse.name; // Si no contiene '@', usa el nombre completo

    return User(
      id: userDbResponse.id,
      name: name,
    );
  }
}
