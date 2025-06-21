import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';

abstract class AuthRepository{
  Future<void> socialLogin(String provider,String accessToken,String clientType);
  Future<Response> login(String userName,String password);
  Future<Response> register(String userName,String password,String email,String phone);
  Future<UserDto> getUserByEmail(String email);
  Future<bool> SendEmail({required String userId});
}