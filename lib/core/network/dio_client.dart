import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/network/auth_interceptor.dart';
import '../../domain/usecases/redis_cacher_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';

class DioClient {
  static Dio create({
    bool withAuthInterceptor = false,
    RedisCacherUseCase? redisCacherUseCase,
    SocialLoginUseCase? socialLoginUseCase,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: "http://192.168.1.190:8080",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'content-type': 'application/json',
      },
    ));

    if (withAuthInterceptor) {
      if (redisCacherUseCase == null || socialLoginUseCase == null) {
        throw ArgumentError('Missing dependencies for AuthInterceptor');
      }
      dio.interceptors.add(AuthInterceptor(redisCacherUseCase, socialLoginUseCase));
    }

    return dio;
  }
}
