import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sheqlee/widget/login/action_dialog.dart';

class AuthUtils {
  static void showLogoutDialog(BuildContext context) {
    showAppDialog(
      context: context,
      title: "Log out",
      // Keeps your exact design and line break
      message: "Are you sure you want to log \nout of your account?",
      actionText: "Log out",
      onConfirm: () async {
        // Show a loading indicator if you wish, or proceed directly to API
        try {
          final response = await http.post(
            Uri.parse('http://192.168.104.238:3000/api/v1/auth/logout'),
            headers: {
              'Content-Type': 'application/json',
              // 'Authorization': 'Bearer $token', // Add if necessary
            },
          );

          if (response.statusCode == 200 || response.statusCode == 204) {
            if (context.mounted) {
              // Navigate to login and remove all previous screens
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          } else {
            _showError(context, "Server error: ${response.statusCode}");
          }
        } catch (e) {
          _showError(context, "Connection failed. Check your network.");
        }
      },
    );
  }

  static void _showError(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }
}
