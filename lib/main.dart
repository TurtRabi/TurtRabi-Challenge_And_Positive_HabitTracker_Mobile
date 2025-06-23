
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_positive_mobile/domain/usecases/redis_cacher_usecase.dart';
import 'package:tracking_positive_mobile/presentation/providers/auth_provider.dart';
import 'package:tracking_positive_mobile/presentation/providers/redis_provider.dart';
import 'package:tracking_positive_mobile/presentation/providers/shared_prefs_provider.dart';
import 'package:tracking_positive_mobile/routes/app_router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final accessKey = prefs.getString('accessKey');
  final refreshKey = prefs.getString('refreshKey');

  final container = ProviderContainer(overrides: [
    sharedPrefsProvider.overrideWithValue(prefs)
  ]);
  String initialRoute = '/login';

  if (refreshKey != null) {
    final useCase = container.read(redisCacherUseCaseProvider);
    final useCaseUser = container.read(socialLoginUseCaseProvider);
    final isValid = await useCase.checkTokenValidity( refreshKey: refreshKey);
    print("isValid: $isValid");
    if (isValid!=null) {
      var userId = refreshKey.split(":")[2].toString().trim();
      //reset token dua tren refresh token
      final resetToken = await useCaseUser.executeRefreshTokenAPI(userId: userId, refreshToken: isValid);
      print(resetToken);
      var setSuccess=await useCase.executeSetRedis(key: accessKey.toString(), value: resetToken, expireTime: 15);
      print(setSuccess);
      //luu lai cai token do trong share reference;
      initialRoute = '/home';
    }
  }
  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute,)));
}
class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: createRouter(initialRoute),
    );
  }
}


