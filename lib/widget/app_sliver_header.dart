import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSliverHeader extends StatelessWidget {
  final String username;

  const AppSliverHeader({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.white,
      pinned: true,
      expandedHeight: 140,
      collapsedHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = ((140.0 - constraints.biggest.height) / (140.0 - 80.0))
              .clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 0.9 - (0.1 * t),
                      child: CircleAvatar(
                        radius: size.width * 0.11,
                        backgroundColor: Colors.black,
                        child: SvgPicture.asset(
                          'assets/icons/settings - alt2 (1).svg',
                          width: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Welcome, $username",
                          style: TextStyle(
                            fontSize: lerpDouble(size.width * 0.045, 16, t),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (t < 0.5) // Only show when expanded
                          Text(
                            "Edit profile",
                            style: TextStyle(
                              color: const Color(0xffa06cd5),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
