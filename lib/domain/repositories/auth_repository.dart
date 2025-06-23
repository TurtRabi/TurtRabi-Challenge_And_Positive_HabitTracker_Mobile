import 'dart:ffi';

import 'package:dio/dio.dart';


import '../../core/Dto/LoginDto.dart';
import '../../core/Dto/UserDto.dart';

abstract class AuthRepository{
  Future<LoginDto> socialLogin(String provider,String accessToken,String clientType);
  Future<LoginDto> login(String userName,String password);
  Future<Response> register(String userName,String password,String email,String phone);
  Future<UserDto> getUserByEmail(String email);
  Future<bool> SendEmail({required String userId});
  Future<bool> changePassword({required String id,required String newPassword});
  Future<String> refreshTokenAPI({required String userId,required String refreshToken});
}