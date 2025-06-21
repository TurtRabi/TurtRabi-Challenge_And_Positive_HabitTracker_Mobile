import 'package:tracking_positive_mobile/domain/repositories/redis_repository.dart';

import '../../core/Dto/RedisDto.dart';

class RedisCacherUseCase{
  final RedisRepository repository;
  RedisCacherUseCase(this.repository);

  Future<RedisDto> executeGetRedisByKey({required String key}){
    return repository.getRedisByKey(key: key);
  }
  
  Future<bool> executeSetRedis({required String key, required String value,required int expireTime}){
    return repository.setRedis(key: key, value: value, expireTime: expireTime);
  }

  Future<bool> executeDeleteRedis({required String key}){
    return repository.deleteRedis(key: key);
  }

}