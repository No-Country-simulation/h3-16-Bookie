import 'package:bookie/config/constants/environment.dart';
import 'package:dio/dio.dart';

class FetchApi {
  static Dio fetchDio() {
    final dio = Dio(BaseOptions(baseUrl: Environment.theUrlDeployBackend));

    return dio;
  }
}
