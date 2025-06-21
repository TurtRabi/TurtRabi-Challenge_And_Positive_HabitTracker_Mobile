import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';

abstract class RedisRepository{
  Future<RedisDto> getRedisByKey({required String key});
  Future<bool> setRedis({required String key, required String value,required int expireTime});
  Future<bool> deleteRedis({required String key});
}