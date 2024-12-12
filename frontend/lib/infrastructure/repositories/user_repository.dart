import 'package:bookie/domain/datasources/user_datasource.dart';
import 'package:bookie/domain/entities/user_entity.dart';
import 'package:bookie/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<List<User>> getWriters() {
    return datasource.getWriters();
  }
}
