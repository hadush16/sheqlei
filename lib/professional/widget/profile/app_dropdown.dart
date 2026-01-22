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
  final Color? hintColor;

  const AppDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.isOpen,
    this.value,
    this.onTap,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            color:
                hintColor ??
                const Color(0xffA0A0A0), // Uses black if passed, else grey
            fontSize: 18,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.normal,
          ),
        ),

        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabel(item),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'pretendard',
                fontWeight: FontWeight.normal,
              ),
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
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: isOpen
                ? const BorderRadius.vertical(top: Radius.circular(15))
                : BorderRadius.circular(70),
            //BorderRadius.circular(70),
            border: Border.all(color: Colors.black, width: 1.2),
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
          maxHeight: 250,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 61, 61, 61),
              width: 1.2,
            ),
          ),
          // THIS FORCES THE DROPDOWN BELOW THE FIELD
          offset: const Offset(0, 0),
          elevation: 1,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(45),
            thickness: WidgetStateProperty.all(6),
            thumbColor: WidgetStateProperty.all(Colors.black),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          // This ensures the item background matches the menu background
          overlayColor: WidgetStatePropertyAll(Color(0xffE0E0E0)),
        ),
      ),
    );
  }
}
