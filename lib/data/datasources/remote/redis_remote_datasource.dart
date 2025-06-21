import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';

class RedisRemoteDatasource{
  final Dio dio;
  RedisRemoteDatasource(this.dio);

  Future<RedisDto> getRedisByKey({required String key}) async {
    final encodedKey = Uri.encodeComponent(key);
    var respone= await dio.get('/user/Redis/get/$encodedKey',
    options: Options(
      headers: {
        'Content-Type': 'application/json',
      }
    ));
    return RedisDto.fromJson(respone.data['data']);
  }

  Future<bool> setRedis({required String key, required String value,required int expireTime}) async {
    var response = await dio.post('/user/Redis/set',data: {
      'key': key,
      'value': value,
      'timeMinute': expireTime
    },options: Options(
      headers: {
        'Content-Type': 'application/json'
      }
    ));

    return response.statusCode == 200;
  }

  Future<bool> deleteRedis({required String key}) async {
    var response = await dio.delete('/user/Redis/remove/$key', options: Options(
        headers: {
          'Content-Type': 'application/json'
        }
    ));

    return response.statusCode == 200;
  }
}