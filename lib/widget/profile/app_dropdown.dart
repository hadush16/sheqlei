import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T?) onChanged;
  final VoidCallback? onTap;
  final bool isOpen;

  const AppDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.isOpen,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          hint,
          style: const TextStyle(
            color: Color(0xffA0A0A0),
            fontSize: 18,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabel(item),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        }).toList(),
        value: value,
        onChanged: onChanged,
        onMenuStateChange: (open) {
          if (onTap != null && open != isOpen) {
            onTap!();
          }
        },
        // --- DESIGN MATCH ---
        buttonStyleData: ButtonStyleData(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            border: Border.all(color: const Color(0xffD0D0D0)),
            color: const Color(0xffF5F5F5),
          ),
        ),
        // Inside AppDropdown icon logic
        iconStyleData: IconStyleData(
          icon: AnimatedRotation(
            turns: isOpen ? 0.5 : 0.0, // 0.5 turns = 180 degrees
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              'assets/icons/arrow-down-sign-to-navigate (2).svg',
              width: 10,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          // THIS FORCES THE DROPDOWN BELOW THE FIELD
          offset: const Offset(0, 1),
          elevation: 1,
        ),
      ),
    );
  }
}
