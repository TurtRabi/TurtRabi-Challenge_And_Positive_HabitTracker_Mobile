import 'package:flutter/cupertino.dart';
import 'package:tracking_positive_mobile/core/Dto/RedisDto.dart';

import '../../domain/usecases/redis_cacher_usecase.dart';

class RedisViewModel extends ChangeNotifier{
  final RedisCacherUseCase redisCacherUseCase;
  RedisViewModel(this.redisCacherUseCase);

  Future<RedisDto> getRedisByKey({required String key}) async{
    var response=await redisCacherUseCase.executeGetRedisByKey(key: key);
    notifyListeners();
    return response;
  }

  Future<void> setRedis({required String key, required String value,required int expireTime}) async{
    await redisCacherUseCase.executeSetRedis(key: key, value: value, expireTime: expireTime);
    notifyListeners();
  }

  Future<void> deleteRedis({required String key}) async{
    await redisCacherUseCase.executeDeleteRedis(key: key);
    notifyListeners();
  }
}