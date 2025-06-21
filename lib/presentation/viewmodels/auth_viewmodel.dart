import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracking_positive_mobile/domain/usecases/social_login_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final SocialLoginUseCase _socialLoginUseCase;
  AuthViewModel(this._socialLoginUseCase);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
    serverClientId: '471889571929-3h3g7q9tl7vvn2m4j45m9gnloc5eaf1v.apps.googleusercontent.com',
  );
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _user = account;
        final authentication = await account.authentication;
        final idToken = authentication.idToken;
        if (idToken != null) {
          await _socialLoginUseCase.execute('google', idToken, 'mobile');
          notifyListeners();
          debugPrint('✅ Google User: ${account.displayName}, Email: ${account.email}');
        } else {
          debugPrint('❌ Không lấy được ID Token! Đảm bảo bạn đã cấu hình đúng serverClientId (Web Client ID).');
        }
      } else {
        debugPrint('⚠️ Người dùng huỷ đăng nhập');
      }
    } catch (e) {
      debugPrint('❌ Lỗi Google login: $e');
    }
  }

  Future<void>sigInWithUserNameAndPassword(String username, String password) async{
    var result = await _socialLoginUseCase.executeLogin(username, password);
    notifyListeners();
    if(result!=null){

    }
  }

  Future<void> registerWithUserNameAndPassword(String username, String password,String email,String phone) async{
    var result = await _socialLoginUseCase.executeRegister(username, password, email, phone);
    notifyListeners();
    if(result!=null){

    }
  }

  Future<bool> SendEmail(String email) async{
    var findUserByEmail = await _socialLoginUseCase.executeGetUserByEmail(email);
    if(findUserByEmail==null){
      return false;
    }
    await _socialLoginUseCase.executeSendEmail(userId: findUserByEmail.id);
    notifyListeners();
    return true;
  }

}
