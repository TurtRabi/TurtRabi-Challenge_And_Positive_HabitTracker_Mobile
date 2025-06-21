
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';
import 'package:tracking_positive_mobile/domain/repositories/auth_repository.dart';

class SocialLoginUseCase{
  final AuthRepository repository;
  SocialLoginUseCase(this.repository);
  Future<void> execute(String provider,String accessToken,String clientType){
    return repository.socialLogin(provider, accessToken, clientType);
  }
  Future<bool> executeLogin(String userName,String password){
    return repository.login(userName, password);
  }
  Future<Response> executeRegister(String userName,String password,String email,String phone){
    return repository.register(userName, password, email, phone);
  }
  Future<UserDto> executeGetUserByEmail(String email){
    return repository.getUserByEmail(email);
  }
  Future<bool> executeSendEmail({required String userId}){
    return repository.SendEmail(userId: userId);
  }
  Future<bool> executeChangePassword({required String id,required String newPassword}){
    return repository.changePassword(id: id, newPassword: newPassword);
  }
}