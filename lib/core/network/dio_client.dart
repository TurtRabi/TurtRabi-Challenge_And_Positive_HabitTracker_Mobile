import 'package:dio/dio.dart';

class DioClient{
  static Dio create(){
    return Dio(BaseOptions(
      baseUrl: "http://192.168.1.40:8080",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'content-type': 'application/json'
      }
    ));
  }
}