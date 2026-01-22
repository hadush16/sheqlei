import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xff8967B3), // Your signature purple
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(70, 30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'pretendard',
        ),
      ),
    );
  }
}
