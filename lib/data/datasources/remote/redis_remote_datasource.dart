import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';

class RedisRemoteDatasource {
  final Dio dio;
  RedisRemoteDatasource(this.dio);

  Future<RedisDto> getRedisByKey({required String key}) async {
    print('🔍 [GET Redis] key: $key');
    final response = await dio.get(
      '/user/Redis/get',
      queryParameters: {
        'key': key,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    print('📤 URL: ${response.requestOptions.uri}');
    print('📥 Response Data: ${response.data}');

    return RedisDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> setRedis({required String key, required String value, required int expireTime}) async {
    print('💾 [SET Redis] key: $key, value: $value, expireTime: $expireTime minutes');

    final response = await dio.post(
      '/user/Redis/set',
      queryParameters: {
        'key': key,
        'value': value,
        'timeMinute': expireTime,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    print('📤 URL: ${response.requestOptions.uri}');
    print('📥 Response Status: ${response.statusCode}, Body: ${response.data}');

    return response.statusCode == 200;
  }

  Future<bool> deleteRedis({required String key}) async {
    print('🗑️ [DELETE Redis] key: $key');

    final response = await dio.delete(
      '/user/Redis/remove',
      queryParameters: {
        'key': key,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    print('📤 URL: ${response.requestOptions.uri}');
    print('📥 Response Status: ${response.statusCode}, Body: ${response.data}');

    return response.statusCode == 200;
  }
}
