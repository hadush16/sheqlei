import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/jobs/favorites_provider.dart';

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
        // Toggle the favorite state in the provider
        ref.read(favoritesProvider.notifier).toggleFavorite(jobId);
      },
      child: SvgPicture.asset(
        isFavorite
            ? 'assets/icons/heart - solid (1).svg'
            : 'assets/icons/heart - solid.svg', // Ensure you have an outline version
        // colorFilter: ColorFilter.mode(
        //   isFavorite ? const Color(0xffa06cd5) : Colors.grey,
        //   BlendMode.srcIn,
        // ),
        width: 22,
      ),
    );
  }
}
