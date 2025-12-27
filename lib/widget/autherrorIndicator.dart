import 'package:flutter/material.dart';

class AuthErrorIndicator extends StatelessWidget {
  final String? errorText;
  const AuthErrorIndicator({super.key, this.errorText});

  @override
  Widget build(BuildContext context) {
    if (errorText == null || errorText!.isEmpty) return const SizedBox.shrink();

    return Text(
      errorText!,
      style: const TextStyle(
        color: Color(0xffEA4335),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
