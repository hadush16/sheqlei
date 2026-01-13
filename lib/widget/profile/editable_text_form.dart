import 'package:flutter/material.dart';

class CustomProfileField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isRequired;
  final int? maxLength;
  final int maxLines;
  final String? initialValue;
  final Function(String)? onChanged;
  final TextEditingController? controller; // Add this

  const CustomProfileField({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.maxLength,
    this.maxLines = 1,
    this.initialValue,
    this.controller,
    this.onChanged,
  });

  @override
  State<CustomProfileField> createState() => _CustomProfileFieldState();
}

class _CustomProfileFieldState extends State<CustomProfileField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffD0D0D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. The Label: Fixed inside at the top
              // Instead of a simple Text(widget.label), use Text.rich
              Text.rich(
                TextSpan(
                  text: widget.label, // The main label text
                  style: const TextStyle(
                    color: Color(0xffA0A0A0), // Your default grey
                    fontSize: 18,
                    fontFamily: 'pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    if (widget.isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red, // Specifically makes the star red
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 2), // Small gap between label and input
              // 2. The Input Field
              TextFormField(
                controller: _controller,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontFamily: 'pretendard',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  // We remove the default borders since the Container handles them
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero, // Fits tightly under label
                  counterText:
                      "", // Hides the character count for a cleaner look
                ),
              ),
              // Optional: Show character count only for Introduction (maxLines > 1)
              if (widget.maxLength != null && widget.maxLines > 1)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${_controller.text.length}/${widget.maxLength}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
