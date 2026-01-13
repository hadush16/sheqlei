import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    this.message = "No job posts,\nplease try again later",
    this.buttonText = "Edit profile",
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/sad.svg',
            width: 75,
            height: 75.04,
            colorFilter: ColorFilter.mode(
              const Color(0xff8967B3).withOpacity(0.6),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
