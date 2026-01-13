import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/jobs/favorites_provider.dart';
import 'package:sheqlee/widget/home/app_sliver_header.dart';
import 'package:sheqlee/widget/home/empty_job_widget.dart';
import 'package:sheqlee/widget/home/job_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteJobs = ref.watch(favoritedJobsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // We keep the body as a CustomScrollView to handle Slivers
      body: CustomScrollView(
        slivers: [
          // 1. THE HEADER (SliverAppBar)
          AppSliverHeader(),

          // 2. THE CONTENT
          favoriteJobs.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: true,
                  child: EmptyStateWidget(
                    message: "No favorites yet",
                    buttonText: "",
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.only(bottom: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return JobCard(job: favoriteJobs[index]);
                    }, childCount: favoriteJobs.length),
                  ),
                ),
        ],
      ),
      //),
    );
  }
}
