import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/redis_provider.dart';

Future<void> showOtpDialog(BuildContext context, WidgetRef ref, String email) async {
  String otpCode = '';
  final mediaQuery = MediaQuery.of(context);
  final screenWidth = mediaQuery.size.width;
  final dialogWidth = screenWidth * 0.9;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Nhập mã xác thực',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: dialogWidth,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Chúng tôi đã gửi mã gồm 6 chữ số tới email của bạn. Vui lòng nhập mã để tiếp tục.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final fieldCount = 6;
                    final spacing = 10.0;
                    final totalSpacing = spacing * (fieldCount - 1);
                    final availableWidth = constraints.maxWidth - totalSpacing;
                    final fieldWidth = availableWidth / fieldCount;

                    return PinCodeTextField(
                      length: fieldCount,
                      appContext: context,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: fieldWidth,
                        fieldWidth: fieldWidth,
                        activeColor: Colors.deepPurple,
                        selectedColor: Colors.deepPurpleAccent,
                        inactiveColor: Colors.grey,
                      ),
                      onChanged: (_) {},
                      onCompleted: (value) {
                        otpCode = value;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (otpCode.length == 6) {
                final getOtp = await ref.read(redisViewModelProvider).getRedisByKey(key: "verify:email:$email");

                if (getOtp.value == otpCode) {
                  await ref.read(redisViewModelProvider).deleteRedis(key: "verify:email:$email");
                  Navigator.of(context).pop();
                  Future.microtask(() => context.go('/reset-password', extra: email));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mã xác thực không đúng.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập đầy đủ 6 chữ số')),
                );
              }
            },
            child: const Text('Xác nhận'),
          ),
        ],
      );
    },
  );
}
