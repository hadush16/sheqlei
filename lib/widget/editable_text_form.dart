import 'package:flutter/material.dart';

class CustomProfileField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isRequired;
  final int? maxLength;
  final int maxLines;
  final String? initialValue;
  final Function(String)? onChanged;

  const CustomProfileField({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.maxLength,
    this.maxLines = 1,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<CustomProfileField> createState() => _CustomProfileFieldState();
}

class _CustomProfileFieldState extends State<CustomProfileField> {
  late TextEditingController _controller;

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
      child: TextFormField(
        controller: _controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: widget.isRequired ? "${widget.label} *" : widget.label,
          alignLabelWithHint: true,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          floatingLabelStyle: const TextStyle(
            color: Color(0xff8967B3),
            fontSize: 16,
          ),
          hintText: widget.hint,
          floatingLabelBehavior:
              FloatingLabelBehavior.auto, // Label inside border
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff8967B3), width: 2),
          ),
        ),
      ),
    );
  }
}
