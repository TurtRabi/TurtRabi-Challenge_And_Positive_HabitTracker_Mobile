import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';
import 'package:tracking_positive_mobile/data/datasources/remote/redis_remote_datasource.dart';
import 'package:tracking_positive_mobile/domain/repositories/redis_repository.dart';

class RedisRepositoryImpl implements RedisRepository{
  final RedisRemoteDatasource datasource;
  RedisRepositoryImpl(this.datasource);
  @override
  Future<bool> deleteRedis({required String key}) {
    return datasource.deleteRedis(key: key);
  }

  @override
  Future<RedisDto> getRedisByKey({required String key}) {
    return datasource.getRedisByKey(key: key);
  }

  @override
  Future<bool> setRedis({required String key, required String value, required int expireTime}) {
    return datasource.setRedis(key: key, value: value, expireTime: expireTime);
  }
  
}