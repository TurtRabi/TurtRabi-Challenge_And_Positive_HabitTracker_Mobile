import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  AuthRepositoryImpl(this.datasource);
  
  @override
  Future<void> socialLogin(String provider, String accessToken, String clientType) {
    return datasource.soicialLogin(provider: provider, accessToken: accessToken, clientType: clientType);
  }

  @override
  Future<Response> login(String userName, String password) {
    return datasource.login(userName: userName, password: password);
  }

  @override
  Future<Response> register(String userName, String password, String email, String phone) {
    return datasource.RegiserUser(userName: userName, password: password, email: email, phone: phone);
  }

  @override
  Future<UserDto> getUserByEmail(String email) {
    return datasource.getUserByEmail(email: email);
  }

  @override
  Future<bool> SendEmail({required String userId}) {
    return datasource.SendEmail(userId: userId);
  }
}