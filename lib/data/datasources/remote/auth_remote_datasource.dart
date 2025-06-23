import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';
import '../../../core/Dto/LoginDto.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<LoginDto> soicialLogin({
    required String provider,
    required String accessToken,
    required String clientType,
  }) async {
    print('🔐 Social Login: provider=$provider, accessToken=$accessToken, clientType=$clientType');
    final response = await dio.post(
      '/user/UserProvider/social-login',
      queryParameters: {
        'provider': provider,
        'accessToken': accessToken,
        'clientType': clientType,
      },
    );
    print('✅ Social Login Response: ${response.statusCode}');
    return LoginDto.fromJson(response.data['data']);
  }

  Future<LoginDto> login({
    required String userName,
    required String password,
  }) async {
    print('🔐 Login started with username=$userName');
    final response = await dio.post(
      '/user/User/login',
      data: {
        'userName': userName,
        'password': password,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('✅ Login response: ${response.data}');
    return LoginDto.fromJson(response.data['data']);
  }

  Future<Response> RegiserUser({
    required String userName,
    required String password,
    required String email,
    required String phone,
  }) async {
    print('📝 Registering user: $userName, $email, $phone');
    final response = await dio.post(
      '/user/User/register',
      data: {
        'username': userName,
        'password': password,
        'email': email,
        'phone': phone,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('✅ Register response: ${response.statusCode}');
    return response;
  }

  Future<UserDto> getUserByEmail({required String email}) async {
    final encodedEmail = Uri.encodeComponent(email);
    print('📧 Getting user by email: $email');
    final response = await dio.get(
      '/user/User/getUserByEmail/$encodedEmail',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('✅ GetUserByEmail response: ${response.data}');
    return UserDto.fromJson(response.data['data']);
  }

  Future<bool> SendEmail({required String userId}) async {
    print('📨 Sending verification email to userId: $userId');
    final response = await dio.post(
      '/user/User/$userId/verify-email/send',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('✅ Email sent: ${response.statusCode == 200}');
    return response.statusCode == 200;
  }

  Future<bool> changePassword({
    required String id,
    required String newPassword,
  }) async {
    print('🔑 Changing password for userId: $id');
    final response = await dio.post(
      '/user/User/change-password/$id/$newPassword',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    print('✅ Password change response: ${response.statusCode}');
    return response.statusCode == 200;
  }

  Future<String> refreshTokenAPI({
    required String userId,
    required String refreshToken,
  }) async {
    try {
      final response = await dio.post(
        '/user/User/$userId/refresh-token',
        queryParameters: {
          'refreshToken': refreshToken,
        },
      );

      return response.data['data']?['token'] ;
    } on DioError catch (e) {
      print('❌ Refresh token API error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

}
