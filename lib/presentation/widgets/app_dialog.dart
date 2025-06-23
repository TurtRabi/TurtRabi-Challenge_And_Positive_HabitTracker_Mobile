import 'package:flutter/material.dart';

enum DialogType { success, error, warning, noConnection }

class AppDialog {
  static void show(
      BuildContext context, {
        required String title,
        required String message,
        required DialogType type,
        VoidCallback? onConfirm,
      }) {
    Icon icon;
    Color color;

    switch (type) {
      case DialogType.success:
        icon = const Icon(Icons.check_circle, color: Colors.green, size: 48);
        color = Colors.green;
        break;
      case DialogType.error:
        icon = const Icon(Icons.error, color: Colors.red, size: 48);
        color = Colors.red;
        break;
      case DialogType.warning:
        icon = const Icon(Icons.warning, color: Colors.orange, size: 48);
        color = Colors.orange;
        break;
      case DialogType.noConnection:
        icon = const Icon(Icons.wifi_off, color: Colors.grey, size: 48);
        color = Colors.grey;
        break;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          children: [
            icon,
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

