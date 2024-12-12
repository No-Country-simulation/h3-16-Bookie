import 'package:bookie/domain/entities/read_entity.dart';

abstract class ReadDatasource {
  Future<List<Read>> getReaders();

  Future<int> addReader(ReadForm readForm);

  Future<int> addReaderChapter(ReadChapterForm readChapterForm);

  Future<void> completeReaderChapter(int readerId);
}
