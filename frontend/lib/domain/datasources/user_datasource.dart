import 'package:bookie/domain/entities/user_entity.dart';

abstract class UserDatasource {
  Future<List<User>> getWriters();
}
