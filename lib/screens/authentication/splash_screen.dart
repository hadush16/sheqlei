import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sheqlee/login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroLoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8C6BB1), // EDIT background color
      body: Stack(
        children: [
          /// ---------- CENTERED LOGO ----------
          Center(
            child: SizedBox(
              width: 120, // EDIT logo width
              height: 120, // EDIT logo height
              child: SvgPicture.asset(
                "assets/icons/settings - alt2.svg", // EDIT your image path
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// ---------- BOTTOM CENTER TEXT ----------
          Positioned(
            left: 0,
            right: 0,
            bottom: 70, // EDIT spacing from bottom
            child: Text(
              "Sheqlee",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40, // EDIT text size
                color: Colors.white,
                // fontfamily: 'Recoleta', // EDIT font family
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
