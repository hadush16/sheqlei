import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.enabled,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xff8967B3);
    final Color inactiveColor = const Color(0xff000000);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? activeColor : inactiveColor,
          disabledBackgroundColor: inactiveColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 47,
                width: 46,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: enabled
                      ? Colors.white
                      : Colors.white, // Color(0xff8967B3),
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
