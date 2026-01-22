import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/providers/jobs/favorites_provider.dart';
import 'package:sheqlee/professional/widget/home/custom_snack_bar.dart';

class FavoriteButton extends ConsumerWidget {
  final String jobId;
  const FavoriteButton({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favorites set to see if this ID is in it
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(jobId);

    return GestureDetector(
      onTap: () {
        // 1. Capture the notifier while the widget is still active
        final favNotifier = ref.read(favoritesProvider.notifier);

        // 2. Check if we are about to remove it
        final wasFavorite = isFavorite;

        // 3. Perform the toggle (this will trigger the widget's disposal in the list)
        favNotifier.toggleFavorite(jobId);

        // 4. Show the SnackBar using the stable notifier reference
        if (wasFavorite) {
          showRemovedSnackBar(context, favNotifier, jobId);
        }
      },
      child: SvgPicture.asset(
        isFavorite
            ? 'assets/icons/heart - solid (1).svg'
            : 'assets/icons/heart - solid.svg', // Ensure you have an outline version

        width: 22,
      ),
    );
  }
}
