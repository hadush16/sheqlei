import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl; // From API/Server
  final String? localFilePath; // From State (profileImagePath)
  final double radius;
  final String fallbackSvg;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.localFilePath,
    required this.radius,
    this.fallbackSvg = 'assets/icons/settings - alt2 (1).svg',
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black,
      // Use child to handle the different image types manually
      child: ClipOval(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    // 1. Priority: Local picked file
    if (localFilePath != null && localFilePath!.isNotEmpty) {
      return Image.file(
        File(localFilePath!),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // 2. Priority: Network Image from API
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // 3. Fallback: SVG Icon
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Center(
      child: SvgPicture.asset(
        fallbackSvg,
        width: radius * 0.9,
        height: radius * 0.9,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
