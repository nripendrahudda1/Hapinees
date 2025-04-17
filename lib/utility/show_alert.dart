import 'package:flutter/material.dart';

class TMessaging {
  static showAlert(BuildContext context, String? title, String? content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Alert'),
          content: Text(content ?? ''),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    ));
  }

  static showSnackBarWithCustom(BuildContext context, String message) {
    // final theme = Provider.of<ThemeStore>(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 200, right: 20, left: 20),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    ));
  }
}
