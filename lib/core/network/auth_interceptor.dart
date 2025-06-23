import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/redis_cacher_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';

class AuthInterceptor extends Interceptor {
  final RedisCacherUseCase redisCacherUseCase;
  final SocialLoginUseCase useCaseUser;

  AuthInterceptor(this.redisCacherUseCase, this.useCaseUser);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessKey = prefs.getString('accessKey');
    final refreshKey = prefs.getString('refreshKey');

    if (accessKey != null && refreshKey != null) {
      final accessToken = await redisCacherUseCase.executeGetRedisByKey(key: accessKey);

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      } else {
        final refreshTokenValue = await redisCacherUseCase.executeGetRedisByKey(key: refreshKey);

        if (refreshTokenValue != null) {
          final userId = refreshKey.split(":").last;

          try {
            final newAccessToken = await useCaseUser.executeRefreshTokenAPI(
              userId: userId,
              refreshToken: refreshTokenValue.toString(),
            );

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await redisCacherUseCase.executeSetRedis(
                key: accessKey,
                value: newAccessToken,
                expireTime: 15,
              );

              options.headers['Authorization'] = 'Bearer $newAccessToken';
              return handler.next(options);
            } else {
              return _rejectSessionExpired(handler, options);
            }
          } catch (_) {
            return _rejectSessionExpired(handler, options);
          }
        } else {
          return _rejectSessionExpired(handler, options);
        }
      }
    }

    return handler.next(options);
  }

  void _rejectSessionExpired(RequestInterceptorHandler handler, RequestOptions options) {
    handler.reject(
      DioError(
        requestOptions: options,
        error: 'Session expired. Please login again.',
        type: DioErrorType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          data: {'message': 'Token expired. Please login again.'},
        ),
      ),
    );
  }
}
