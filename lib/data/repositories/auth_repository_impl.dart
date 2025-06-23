import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/LoginDto.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<LoginDto> socialLogin(String provider, String accessToken, String clientType) {
    print('🌐 [AuthRepository] socialLogin → provider: $provider, accessToken: $accessToken, clientType: $clientType');
    return datasource.soicialLogin(provider: provider, accessToken: accessToken, clientType: clientType);
  }

  @override
  Future<LoginDto> login(String userName, String password) {
    print('🔐 [AuthRepository] login → userName: $userName');
    return datasource.login(userName: userName, password: password);
  }

  @override
  Future<Response> register(String userName, String password, String email, String phone) {
    print('📝 [AuthRepository] register → userName: $userName, email: $email, phone: $phone');
    return datasource.RegiserUser(userName: userName, password: password, email: email, phone: phone);
  }

  @override
  Future<UserDto> getUserByEmail(String email) {
    print('📩 [AuthRepository] getUserByEmail → email: $email');
    return datasource.getUserByEmail(email: email);
  }

  @override
  Future<bool> SendEmail({required String userId}) {
    print('📤 [AuthRepository] SendEmail → userId: $userId');
    return datasource.SendEmail(userId: userId);
  }

  @override
  Future<bool> changePassword({required String id, required String newPassword}) {
    print('🔑 [AuthRepository] changePassword → id: $id, newPassword: $newPassword');
    return datasource.changePassword(id: id, newPassword: newPassword);
  }

  @override
  Future<String> refreshTokenAPI({required String userId, required String refreshToken}) {
    return datasource.refreshTokenAPI(userId: userId, refreshToken: refreshToken);
  }
}
