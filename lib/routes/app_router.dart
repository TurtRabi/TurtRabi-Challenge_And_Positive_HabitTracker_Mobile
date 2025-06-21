
import 'package:go_router/go_router.dart';


import '../presentation/pages/AuthenticatePage/forgotPassword/forgot_password_page.dart';
import '../presentation/pages/AuthenticatePage/forgotPassword/reset_password_page.dart';
import '../presentation/pages/AuthenticatePage/login_page.dart';
import '../presentation/pages/AuthenticatePage/sign_up_page.dart';
import '../presentation/pages/HomePage/home_controller_page.dart';


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
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordPage()
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeControllerPage(),
    ),
  ]
);