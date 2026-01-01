import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool isPassword;
  final bool iscode;
  final bool obscureText;
  final bool hasError;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = false,
    this.hasError = false,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.iscode = false,
    this.validator, // 2. Add this
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Fixed height keeps everything stable
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // 1. THE UNDERLINE
          Container(
            height: 1,
            color: hasError ? const Color(0xffEA4335) : Colors.black12,
          ),

          // 2. THE INPUT BOX
          Positioned(
            bottom: 5,
            top: 2, // Negative offset to sit text on the line
            left: 2,
            right: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: validator,
                    inputFormatters: iscode
                        ? [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ]
                        : null,
                    controller: controller,
                    cursorColor: Color(0xff8967B3),
                    focusNode: focusNode,
                    obscureText: isPassword ? obscureText : false,
                    onChanged: onChanged,
                    keyboardType: keyboardType,
                    autofocus: autofocus, // Fixed: Now correctly applied
                    style: TextStyle(
                      fontSize: obscureText ? 40 : 23,
                      fontFamily: 'Pretendard',
                      height: 1.0,
                      letterSpacing: (obscureText) ? -10.0 : 0,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Color(0xffD0D0D0),
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                      isCollapsed: true,
                      border: InputBorder.none,
                      // Removed suffixIcon from here to prevent alignment shift
                    ),
                  ),
                ),

                // 3. SUFFIX ICON (Positioned manually to avoid pushing text up)
                if (suffixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.2),
                    child: suffixIcon!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
