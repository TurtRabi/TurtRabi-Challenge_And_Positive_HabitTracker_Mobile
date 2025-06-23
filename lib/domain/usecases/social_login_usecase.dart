import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tracking_positive_mobile/core/Dto/LoginDto.dart';
import 'package:tracking_positive_mobile/core/Dto/UserDto.dart';
import 'package:tracking_positive_mobile/domain/repositories/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository repository;

  SocialLoginUseCase(this.repository);

  Future<LoginDto> execute(String provider, String accessToken, String clientType) {
    print('🌐 [SocialLoginUseCase] execute → provider: $provider, accessToken: $accessToken, clientType: $clientType');
    return repository.socialLogin(provider, accessToken, clientType);
  }

  Future<LoginDto> executeLogin(String userName, String password) {
    print('🔐 [SocialLoginUseCase] executeLogin → userName: $userName');
    return repository.login(userName, password);
  }

  Future<Response> executeRegister(String userName, String password, String email, String phone) {
    print('📝 [SocialLoginUseCase] executeRegister → userName: $userName, email: $email, phone: $phone');
    return repository.register(userName, password, email, phone);
  }

  Future<UserDto> executeGetUserByEmail(String email) {
    print('📧 [SocialLoginUseCase] executeGetUserByEmail → email: $email');
    return repository.getUserByEmail(email);
  }

  Future<bool> executeSendEmail({required String userId}) {
    print('📤 [SocialLoginUseCase] executeSendEmail → userId: $userId');
    return repository.SendEmail(userId: userId);
  }

  Future<bool> executeChangePassword({required String id, required String newPassword}) {
    print('🔑 [SocialLoginUseCase] executeChangePassword → id: $id');
    return repository.changePassword(id: id, newPassword: newPassword);
  }

  Future<String> executeRefreshTokenAPI({required String userId, required String refreshToken}) {
    return repository.refreshTokenAPI(userId: userId, refreshToken: refreshToken);
  }
}
