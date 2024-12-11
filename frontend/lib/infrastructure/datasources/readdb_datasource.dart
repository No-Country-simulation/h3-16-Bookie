import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/datasources/read_datasource.dart';
import 'package:bookie/domain/entities/read_entity.dart';
import 'package:bookie/infrastructure/mappers/readdb_mapper.dart';
import 'package:bookie/infrastructure/models/read_db.dart';

class ReadDbDatasource extends ReadDatasource {
  @override
  Future<List<Read>> getReaders() async {
    try {
      final userId = await SharedPreferencesKeys.getCredentials()
          .then((value) => int.parse(value.id ?? '0'));

      final response = await FetchApi.fetchDio().get('/v1/reader/$userId');

      final readDBResponse = ReadDbResponse.fromJsonList(response.data);

      final List<Read> reads = readDBResponse
          .map((readdb) => ReadMapper.readDbToEntity(readdb))
          .toList();

      // ordena los reads chapters por orden ascendente en id
      for (var read in reads) {
        read.story.chapters.sort((a, b) => a.id.compareTo(b.id));
      }

      return reads;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int> addReader(ReadForm readForm) async {
    try {
      final response = await FetchApi.fetchDio().post(
        '/v1/reader',
        data: readForm.toJson(),
      );

      return response.data?['id'];

    } catch (e) {
      throw Exception("Error al agregar la lectura");
    }
  }

  @override
  Future<int> addReaderChapter(ReadChapterForm readChapterForm) async {
    try {
      final response = await FetchApi.fetchDio().post(
        '/v1/reader-chapter',
        data: readChapterForm.toJson(),
      );

      return response.data?['id'];
    } catch (e) {
      throw Exception("Error al agregar el capítulo del lector");
    }
  }

  @override
  Future<void> completeReaderChapter(int readerId) async {
    try {
      await FetchApi.fetchDio().patch(
        '/v1/reader-chapter/$readerId',
      );
    } catch (e) {
      throw Exception("Error al completar el capítulo del lector");
    }
  }
}
