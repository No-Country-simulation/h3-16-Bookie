import 'package:bookie/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<User>> getWriters();
}
