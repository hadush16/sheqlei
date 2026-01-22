import 'dart:math' as math show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatherSvgLoader extends StatefulWidget {
  final double size;
  const FeatherSvgLoader({super.key, this.size = 40.0});

  @override
  State<FeatherSvgLoader> createState() => _FeatherSvgLoaderState();
}

class _FeatherSvgLoaderState extends State<FeatherSvgLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: SvgPicture.asset(
        'assets/icons/Icon feather-loader (1).svg',
        width: widget.size,
        height: widget.size,
        colorFilter: const ColorFilter.mode(Color(0xffa06cd5), BlendMode.srcIn),
      ),
    );
  }
}
