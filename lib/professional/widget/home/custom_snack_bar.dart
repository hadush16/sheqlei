import 'package:flutter/material.dart';
import 'package:sheqlee/professional/providers/jobs/favorites_provider.dart';

void showRemovedSnackBar(
  BuildContext context,
  FavoritesNotifier notifier,
  String jobId,
) {
  showModalBottomSheet(
    context: context,
    // This dims the background (low white / grey)
    barrierColor: Colors.black.withOpacity(0.3),
    backgroundColor: Colors.transparent,
    elevation: 0,
    builder: (context) {
      return Padding(
        // Position it at the bottom like a SnackBar
        padding: const EdgeInsets.only(bottom: 70, left: 40, right: 40),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white, // Pure white background
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Removed from favorites',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Action still works because notifier is stable
                  notifier.toggleFavorite(jobId);
                  Navigator.pop(context); // Close the "SnackBar"
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff8967B3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text(
                  'Undo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
