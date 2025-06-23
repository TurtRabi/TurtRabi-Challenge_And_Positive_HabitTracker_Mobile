import 'package:flutter/cupertino.dart';
import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';

import '../../domain/usecases/redis_cacher_usecase.dart';

class RedisViewModel extends ChangeNotifier {
  final RedisCacherUseCase redisCacherUseCase;
  RedisViewModel(this.redisCacherUseCase);

  Future<RedisDto> getRedisByKey({required String key}) async {
    print('🔍 [RedisViewModel] Getting value for key: $key');
    try {
      final response = await redisCacherUseCase.executeGetRedisByKey(key: key);
      print('✅ [RedisViewModel] Retrieved: ${response.value}');
      notifyListeners();
      return response;
    } catch (e) {
      print('❌ [RedisViewModel] Error getting key $key: $e');
      rethrow;
    }
  }

  Future<void> setRedis({required String key, required String value, required int expireTime}) async {
    print('📝 [RedisViewModel] Setting key: $key with value: $value (expires in $expireTime minutes)');
    try {
      await redisCacherUseCase.executeSetRedis(key: key, value: value, expireTime: expireTime);
      print('✅ [RedisViewModel] Set success');
      notifyListeners();
    } catch (e) {
      print('❌ [RedisViewModel] Error setting key $key: $e');
    }
  }

  Future<void> deleteRedis({required String key}) async {
    print('🗑️ [RedisViewModel] Deleting key: $key');
    try {
      await redisCacherUseCase.executeDeleteRedis(key: key);
      print('✅ [RedisViewModel] Deleted key: $key');
      notifyListeners();
    } catch (e) {
      print('❌ [RedisViewModel] Error deleting key $key: $e');
    }
  }
}
