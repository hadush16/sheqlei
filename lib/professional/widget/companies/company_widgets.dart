import 'package:flutter/material.dart';

class CompanyMetaTag extends StatelessWidget {
  final String label;
  const CompanyMetaTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xff303030)),
      ),
    );
  }
}
