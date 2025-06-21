import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';

class AuthRemoteDatasource{
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<Response> soicialLogin({
    required String provider,
    required String accessToken,
    required String clientType,

  }) async {
    return await dio.post('/user/UserProvider/social-login',queryParameters: {
      'provider': provider,
      'accessToken': accessToken,
      'clientType': clientType,
    },);
  }

  Future<Response> login({
    required String userName,
    required String password
  }) async {
    return await dio.post('/user/User/login',data: {
      'userName': userName,
      'password': password,
    },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> RegiserUser({
    required String userName,
    required String password,
    required String email,
    required String phone,
  }) async {
    return await dio.post('/user/User/register',data: {
      'username': userName,
      'password': password,
      'email': email,
      'phone': phone
    },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<UserDto> getUserByEmail({required String email}) async {
    final encodedEmail = Uri.encodeComponent(email);
    var respone= await dio.get(
      '/user/User/getUserByEmail/$encodedEmail',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    return UserDto.fromJson(respone.data['data']);
  }

  Future<bool> SendEmail({required String userId}) async {
    var response = await dio.post(
      '/user/User/${userId}/verify-email/send',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response.statusCode == 200;

  }

}