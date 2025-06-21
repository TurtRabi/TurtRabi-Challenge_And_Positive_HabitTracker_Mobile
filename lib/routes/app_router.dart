
import 'package:go_router/go_router.dart';

import '../presentation/pages/forgotPassword/forgot_password_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/sign_up_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage()
    )
  ]
);