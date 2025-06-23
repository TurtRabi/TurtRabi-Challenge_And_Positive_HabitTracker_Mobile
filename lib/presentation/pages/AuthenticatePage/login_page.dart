import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_positive_mobile/presentation/widgets/log_overlay_service.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    userNameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF5F3FF),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 340,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                    ),
                    child: buildForm(context),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Đăng nhập", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        TextField(
          controller: userNameCtrl,
          decoration: const InputDecoration(
              labelText: 'Tên đăng nhập',
              border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person)
          ),

        ),
        const SizedBox(height: 16),
        TextField(
          controller: passCtrl,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
              labelText: 'Mật khẩu',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(value: _rememberMe, onChanged: (value) => setState(() => _rememberMe = value ?? false)),
            const Flexible(child: Text("Ghi nhớ đăng nhập")),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push('/forgot-password'),
            child: const Text("Quên mật khẩu?"),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Đăng nhập'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Chưa có tài khoản?"),
            TextButton(onPressed: () => context.go('/signup'), child: const Text("Đăng ký")),
          ],
        ),
        const SizedBox(height: 8),
        Text("──────  Hoặc  ──────", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade400)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isLoading
              ? null
              : () async {
            setState(() => _isLoading = true);
            final result = await ref.read(authViewModelProvider).signInWithGoogle();
            if (result) {
              LogOverlayService.show(context,
                message: 'Đăng nhập thành công',
                type: LogType.success,
                duration: const Duration(seconds: 3),
              );
              await Future.delayed(const Duration(milliseconds: 800));
              context.go('/home');
              setState(() => _isLoading = false);
            }
          },
          icon: Image.asset('assets/images/icons8-google-48.png', width: 24, height: 24),
          label: const Text('Đăng nhập với Google'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Future<void> handleLogin() async {
    FocusScope.of(context).unfocus();
    final email = userNameCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      LogOverlayService.show(context,
        message: 'Vui lòng nhập đầy đủ thông tin',
        type: LogType.warning,
        duration: const Duration(seconds: 3),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(authViewModelProvider)
          .sigInWithUserNameAndPassword(email, pass, rememberMe: _rememberMe);
      if (result) {
        LogOverlayService.show(context,
          message: 'Đăng nhập thành công',
        type: LogType.success,
        duration: const Duration(seconds: 3),
        );
        await Future.delayed(const Duration(milliseconds: 800));
        context.go('/home');
      } else {
        LogOverlayService.show(context,
          message: 'Sai tên đăng nhập hoặc mật khẩu',
          type: LogType.error,
          duration: const Duration(seconds: 3),
        );
        await Future.delayed(const Duration(milliseconds: 800));

      }
    } catch (e) {
      LogOverlayService.show(context,
        message: 'Lỗi: $e',
        type: LogType.error,
        duration: const Duration(seconds: 3),
      );
      await Future.delayed(const Duration(milliseconds: 800));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
