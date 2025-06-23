import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracking_positive_mobile/domain/usecases/social_login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/Dto/LoginDto.dart';

class AuthViewModel extends ChangeNotifier {
  final SocialLoginUseCase _socialLoginUseCase;
  AuthViewModel(this._socialLoginUseCase);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '471889571929-3h3g7q9tl7vvn2m4j45m9gnloc5eaf1v.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<bool> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _user = account;
        final authentication = await account.authentication;
        final idToken = authentication.idToken;
        if (idToken != null) {
          final result = await _socialLoginUseCase.execute('google', idToken, 'mobile');
          notifyListeners();

          final prefs = await SharedPreferences.getInstance();
          // ✅ Lưu access token và refresh token nếu login thành công

          await prefs.setString('accessKey', 'auth:token:${result.userId}');
          await prefs.setString('refreshKey', 'auth:refresh:${result.userId}');
          print('💾 [Google SignIn] Token saved');

          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ [Google SignIn] Error: $e');
      return false;
    }
  }



  Future<bool> sigInWithUserNameAndPassword(String username, String password, {bool rememberMe = false}) async {
    print('🔐 [Login] username: $username');
    try {
      final result = await _socialLoginUseCase.executeLogin(username, password);
      notifyListeners();
      if (result != null) {
        print('✅ [Login] Success: $result');


        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessKey', 'auth:token:${result.userId}');
        if (rememberMe) {
          await prefs.setString('refreshKey', 'auth:refresh:${result.userId}');
          print("userId"+result.userId);
          print('💾 [Login] Credentials saved');
        }

        return true;
      } else {
        print('❌ [Login] Failed: null response');
        return false;
      }
    } catch (e) {
      print('❌ [Login] Error: $e');
      return false;
    }
  }


  Future<void> registerWithUserNameAndPassword(String username, String password, String email, String phone) async {
    print('📝 [Register] username: $username, email: $email, phone: $phone');
    try {
      final result = await _socialLoginUseCase.executeRegister(username, password, email, phone);
      notifyListeners();
      print('✅ [Register] Completed: ${result.statusCode}');
    } catch (e) {
      print('❌ [Register] Error: $e');
    }
  }

  Future<bool> SendEmail(String email) async {
    print('📧 [SendEmail] email: $email');
    try {
      final user = await _socialLoginUseCase.executeGetUserByEmail(email);
      if (user == null) {
        print('❌ [SendEmail] No user found with email: $email');
        return false;
      }
      final sent = await _socialLoginUseCase.executeSendEmail(userId: user.id);
      print('📤 [SendEmail] Email sent to userId: ${user.id}, result: $sent');
      notifyListeners();
      return sent;
    } catch (e) {
      print('❌ [SendEmail] Error: $e');
      return false;
    }
  }

  Future<bool> changePassword(String email, String newPassword) async {
    print('🔑 [ChangePassword] email: $email');
    try {
      final user = await _socialLoginUseCase.executeGetUserByEmail(email);
      if (user == null) {
        print('❌ [ChangePassword] No user found with email: $email');
        return false;
      }
      final result = await _socialLoginUseCase.executeChangePassword(id: user.id, newPassword: newPassword);
      notifyListeners();
      print('✅ [ChangePassword] Result: $result');
      return result;
    } catch (e) {
      print('❌ [ChangePassword] Error: $e');
      return false;
    }
  }
}
