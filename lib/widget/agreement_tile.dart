import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementTile extends StatelessWidget {
  final bool isRequired;
  final bool isChecked;
  final String title;
  final Function(bool) onChanged;
  final VoidCallback onArrowTap;

  const AgreementTile({
    super.key,
    required this.isRequired,
    required this.isChecked,
    required this.title,
    required this.onChanged,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //padding: const EdgeInsets.symmetric(vertical: 4),
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Checkbox
            Transform.scale(
              scale: 0.9, //
              child: SvgPicture.asset(
                isChecked
                    ? 'assets/icons/check-button-filled.svg' // Path to your checked SVG
                    : 'assets/icons/check-button-outline.svg',
                width: 20,
                height: 20,
              ),
            ),

            const SizedBox(width: 3),

            // 2. Required Star (*)
            if (isRequired)
              const Text(
                '* ',
                style: TextStyle(
                  color: Color(0xff8967B3),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'pretendard',

                  fontSize: 15,
                ),
              ),
            // const SizedBox(width: 1),

            // 3. Title (Clickable to toggle checkbox)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!isChecked),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),

            // 4. The Arrow (Url Opener)
            IconButton(
              onPressed: onArrowTap,
              icon: const Icon(Icons.chevron_right, color: Color(0xffA0A0A0)),
            ),
          ],
        ),
      ),
    );
  }
}
