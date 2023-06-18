import 'package:dio/dio.dart';

class DioHelper {

  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.googleapis.com/books/v1',
        receiveDataWhenStatusError: true,
      ),
    );

  }

  static Future<Response?> getData({
    required String url,
    Map<String , dynamic>? query,
}) async {

    dio?.options.headers = {
      'Accept': 'application/json',
    };

    return await dio?.get(url , queryParameters: query);

  }


}