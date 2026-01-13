import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final bool isVisible;
  final String heroTag; // 1. Define the parameter

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    this.iconPath = 'assets/icons/search-alt2.svg',
    this.isVisible = true,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return FloatingActionButton(
      backgroundColor: const Color(0xff8967B3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      onPressed: onPressed,
      heroTag: heroTag,
      child: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
