import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Future<void> showOtpDialog(BuildContext context) async {
  String otpCode = '';
  final mediaQuery = MediaQuery.of(context);
  final screenWidth = mediaQuery.size.width;
  final dialogWidth = screenWidth * 0.9; // chiếm 90% chiều ngang

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter Verification Code'),
        content: Container(
          width: dialogWidth,
          constraints: BoxConstraints(maxWidth: 400), // không vượt quá 400
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'We have sent a 6-digit code to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth < 360 ? 14 : 16),
                ),
                SizedBox(height: 16),
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
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: fieldWidth,
                        fieldWidth: fieldWidth,
                        activeColor: Colors.blue,
                        selectedColor: Colors.blueAccent,
                        inactiveColor: Colors.grey,
                      ),
                      onChanged: (value) {},
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (otpCode.length == 6) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/reset-password');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter all 6 digits')),
                );
              }
            },
            child: Text('Verify'),
          ),
        ],
      );
    },
  );
}
