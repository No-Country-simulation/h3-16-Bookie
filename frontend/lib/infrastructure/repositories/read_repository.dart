

import 'package:bookie/domain/datasources/read_datasource.dart';
import 'package:bookie/domain/entities/read_entity.dart';
import 'package:bookie/domain/repositories/reader_repository.dart';

class ReadRepositoryImpl extends ReadRepository {
  final ReadDatasource datasource;

  ReadRepositoryImpl(this.datasource);

  @override
  Future<List<Read>> getReaders() {
    return datasource.getReaders();
  }

  @override
  Future<int> addReader(ReadForm readForm) {
    return datasource.addReader(readForm);
  }

  @override
  Future<int> addReaderChapter(ReadChapterForm readChapterForm) {
    return datasource.addReaderChapter(readChapterForm);
  }

  @override
  Future<void> completeReaderChapter(int readerId) {
    return datasource.completeReaderChapter(readerId);
  }
}
