import 'package:tracking_positive_mobile/domain/repositories/redis_repository.dart';
import '../../core/Dto/RedisDto.dart';

class RedisCacherUseCase {
  final RedisRepository repository;

  RedisCacherUseCase(this.repository);

  Future<RedisDto> executeGetRedisByKey({required String key}) {
    print('🔍 [RedisCacherUseCase] executeGetRedisByKey → key: $key');
    return repository.getRedisByKey(key: key);
  }

  Future<bool> executeSetRedis({required String key, required String value, required int expireTime}) {
    print('📝 [RedisCacherUseCase] executeSetRedis → key: $key, value: $value, expireTime: $expireTime');
    return repository.setRedis(key: key, value: value, expireTime: expireTime);
  }

  Future<bool> executeDeleteRedis({required String key}) {
    print('🗑️ [RedisCacherUseCase] executeDeleteRedis → key: $key');
    return repository.deleteRedis(key: key);
  }

  Future<String?> checkTokenValidity({required String refreshKey}) async {
    print("run");
    try {
      final refreshExists = await repository.getRedisByKey(key: refreshKey);
      if(refreshExists != null){
        return refreshExists.value.toString();
      }
      return null;
    } catch (_) {
      print("error");
      return null;
    }

  }

}
