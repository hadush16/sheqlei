import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final int level; // The numeric skill level (1-5)

  const LevelIndicator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        int currentNumber = index + 1;
        // If the circle's number is <= the skill level, highlight it black
        bool isSelected = currentNumber <= level;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.black : const Color(0xffD9D9D9),
          ),
          alignment: Alignment.center,
          child: Text(
            "$currentNumber",
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xffA0A0A0),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

Widget buildDisplayField({required String label, required Widget content}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Container(
      // Remove width: double.infinity if this is inside a Row or an unconstrained parent
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffE0E0E0)),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensure it only takes needed vertical space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          content, // The skills list or CV text goes here
        ],
      ),
    ),
  );
}
