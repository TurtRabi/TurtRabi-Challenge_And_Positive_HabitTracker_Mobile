import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/AuthenticatePage/forgotPassword/forgot_password_page.dart';
import '../presentation/pages/AuthenticatePage/forgotPassword/reset_password_page.dart';
import '../presentation/pages/AuthenticatePage/login_page.dart';
import '../presentation/pages/AuthenticatePage/sign_up_page.dart';
import '../presentation/pages/HomePage/home_controller_page.dart';

CustomTransitionPage buildPageWithTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

// ✅ CHỈNH: truyền initialRoute vào
GoRouter createRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithTransition(const LoginPage(), state),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => buildPageWithTransition(const SignUpPage(), state),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => buildPageWithTransition(const ForgotPasswordPage(), state),
      ),
      GoRoute(
        path: '/reset-password',
        pageBuilder: (context, state) => buildPageWithTransition(const ResetPasswordPage(), state),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => buildPageWithTransition(const HomeControllerPage(), state),
      ),
    ],
  );
}
