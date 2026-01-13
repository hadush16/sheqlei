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
  final bool useBorder;
  final String? labelText;

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
    this.useBorder = false, // Default is your original underline style
    this.labelText,
    String? errorText,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = labelText != null
        ? Text.rich(
            TextSpan(
              text: labelText!.replaceAll('*', ''),
              children: [
                if (labelText!.contains('*'))
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          )
        : null;

    if (useBorder) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          // The fixed rectangular border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError ? Colors.red : Colors.grey.shade300,
              width: 1.50,
            ),
          ),
          child: Stack(
            children: [
              // 1. THE LABEL (Inside using negative/small offset)
              if (labelText != null)
                Positioned(
                  top: 10, // Adjust this for the "inside" look
                  left: 8,
                  child: Text.rich(
                    TextSpan(
                      text: labelText!.replaceAll('*', ''),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'pretendard',
                      ),
                      children: [
                        if (labelText!.contains('*'))
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'pretendard',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // 2. THE INPUT FIELD
              TextFormField(
                controller: controller,
                validator: validator,
                obscureText: isPassword ? obscureText : false,
                onChanged: onChanged,
                keyboardType: keyboardType,
                cursorColor: const Color(0xff8967B3),

                // --- CURSOR HEIGHT FIX ---
                style: TextStyle(
                  fontSize: (isPassword && obscureText) ? 45 : 26,
                  fontFamily: 'Pretendard',
                  // height < 1.0 makes the cursor shorter than the font size
                  height: (obscureText) ? 0.4 : 1,
                  letterSpacing: (obscureText) ? -11 : 0,
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
                  border: InputBorder
                      .none, // Hide default border to use Container border
                  // Padding pushes the input text down to leave room for the label
                  contentPadding: const EdgeInsets.only(
                    left: 10,
                    right: 25,
                    top: 50, // Creates space for the manual label above
                    bottom: 15,
                  ),

                  // --- SMALL OBSCURE ICON ---
                  suffixIcon: suffixIcon != null
                      ? Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ), // Aligns with text
                          child: Transform.scale(
                            scale: 0.65,
                            child: suffixIcon,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 32, // Fixed height keeps everything stable
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // 1. THE UNDERLINE
          if (!useBorder)
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
                      height: (obscureText) ? 0.4 : 1,
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

    // return SizedBox(
    //   height: 32, // Fixed height keeps everything stable
    //   child: Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       // 1. THE UNDERLINE
    //       Container(
    //         height: 1,
    //         color: hasError ? const Color(0xffEA4335) : Colors.black12,
    //       ),

    //       // 2. THE INPUT BOX
    //       Positioned(
    //         bottom: 5,
    //         top: 2, // Negative offset to sit text on the line
    //         left: 2,
    //         right: 2,
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             Expanded(
    //               child: TextFormField(
    //                 validator: validator,
    //                 inputFormatters: iscode
    //                     ? [
    //                         FilteringTextInputFormatter.digitsOnly,
    //                         LengthLimitingTextInputFormatter(6),
    //                       ]
    //                     : null,
    //                 controller: controller,
    //                 cursorColor: Color(0xff8967B3),
    //                 focusNode: focusNode,
    //                 obscureText: isPassword ? obscureText : false,
    //                 onChanged: onChanged,
    //                 keyboardType: keyboardType,
    //                 autofocus: autofocus, // Fixed: Now correctly applied
    //                 style: TextStyle(
    //                   fontSize: obscureText ? 40 : 23,
    //                   fontFamily: 'Pretendard',
    //                   height: 1.0,
    //                   letterSpacing: (obscureText) ? -10.0 : 0,
    //                 ),
    //                 decoration: InputDecoration(
    //                   hintText: hintText,
    //                   hintStyle: TextStyle(
    //                     color: Color(0xffD0D0D0),
    //                     fontSize: 18,
    //                     fontFamily: 'Pretendard',
    //                     fontWeight: FontWeight.w500,
    //                     letterSpacing: 0,
    //                   ),
    //                   isCollapsed: true,
    //                   border: InputBorder.none,
    //                   // Removed suffixIcon from here to prevent alignment shift
    //                 ),
    //               ),
    //             ),

    //             // 3. SUFFIX ICON (Positioned manually to avoid pushing text up)
    //             if (suffixIcon != null)
    //               Padding(
    //                 padding: const EdgeInsets.only(bottom: 0.2),
    //                 child: suffixIcon!,
    //               ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
