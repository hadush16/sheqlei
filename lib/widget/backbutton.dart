import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // This removes the 16px default padding of IconButton
      // to allow the -18 offset alignment
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed:
          onTap ??
          () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
      icon: Transform.translate(
        offset: const Offset(-18, 0),
        child: SvgPicture.asset(
          'assets/icons/arrow-down-sign-to-navigate.svg',
          width: 11,
          height: 20,
        ),
      ),
    );
  }
}
