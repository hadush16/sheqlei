import 'package:flutter/material.dart';

Widget getCompanyLogo(String companyId) {
  // Map your Backend IDs to your Local Assets
  String assetPath;

  switch (companyId) {
    case '696520b6a327199c91bc6e8c': // Replace with actual ID from your Postman response
      assetPath = 'assets/icons/microsoft_PNG5.png';
      break;
    case '6964b26708aa89c7246cc479':
      assetPath = 'assets/icons/microsoft_PNG5.png';
      break;
    default:
      // Fallback image if the ID doesn't match
      assetPath = 'assets/icons/microsoft_PNG5.png';
  }

  return Image.asset(
    assetPath,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.business, size: 40),
  );
}
