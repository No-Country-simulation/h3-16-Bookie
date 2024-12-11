import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/config/helpers/extract_name.dart';
import 'package:bookie/config/helpers/get_image_gender_person.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/datasources/user_datasource.dart';
import 'package:bookie/domain/entities/user_entity.dart';
import 'package:bookie/infrastructure/mappers/userdb_mapper.dart';
import 'package:bookie/infrastructure/models/user_db.dart';

class UserDbDatasource extends UserDatasource {
  @override
  Future<List<User>> getWriters() async {
    try {
      final response = await FetchApi.fetchDio().get('/auth/users');

      final userDBResponse = UserDb.fromJsonList(response.data);

      final List<User> writers =
          userDBResponse.map(UserMapper.userDbToEntity).toList();

      // Obtener la imagen de los escritores
      final writersWithImageUrl = await Future.wait(
        writers.map((writer) async {
          final imageUrl =
              await ImageGenderPerson.getImageFromNameWritter(writer.name);

          // aprovechas para añadir la imagen de la persona en su perfil
          final credentials = await SharedPreferencesKeys.getCredentials();

          final nameCredentials = extractName(credentials.name ?? '');

          if (writer.name == nameCredentials) {
            await SharedPreferencesKeys.setImageUrl(imageUrl);
          }

          return writer.copyWith(imageUrl: imageUrl);
        }),
      );

      return writersWithImageUrl;
    } catch (e) {
      return [];
    }
  }
}
