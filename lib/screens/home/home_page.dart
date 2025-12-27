import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/screens/home/job_details_screen.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'dart:math' as math;
import 'package:sheqlee/widget/app_sliver_header.dart';
import 'package:sheqlee/widget/job_shimmer_loading.dart';
import '../../models/job.dart';
import 'package:sheqlee/providers/job_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final isFetchingMore = ref.watch(jobsProvider.notifier).isFetchingMore;

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff8967B3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          //side: BorderSide(color: Colors.white, width: 2),
        ),

        onPressed: () {},
        child: SvgPicture.asset(
          'assets/icons/search-alt2.svg',
          color: Colors.white,
        ),
      ),
      body: CustomRefreshIndicator(
        onRefresh: () => ref.read(jobsProvider.notifier).refreshJobs(),
        builder: (BuildContext context, Widget child, IndicatorController controller) {
          return Stack(
            children: [
              child, // The CustomScrollView (List + App Bar)
              // 🔹 Custom SVG Spinner: Positioned at top-center below the header area
              // Using controller.status to check if we are pulling or refreshing
              if (controller.value > 0)
                Positioned(
                  top:
                      140, // Adjust this to sit right below your specific header
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: controller.value.clamp(0.0, 1.0),
                      child: const FeatherSvgLoader(size: 35),
                    ),
                  ),
                ),
            ],
          );
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. App Bar that resizes automatically
            AppSliverHeader(username: widget.username),

            //const Divider(),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1, // The space the divider occupies
                thickness: 1, // The thickness of the line
                color: Color(0xFFEEEEEE), // Adjust color to match your UI
                indent: 20, // Optional: space from the left
                endIndent: 20, // Optional: space from the right
              ),
            ),

            // 2. Body Content
            jobsAsync.when(
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                //child: Center(child: FeatherSvgLoader()),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Error: $err"),
                  ),
                ),
              ),
              data: (jobs) {
                if (jobs.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centers vertically
                        children: [
                          // 1. Your Sad SVG Picture
                          SvgPicture.asset(
                            'assets/icons/sad.svg', // Ensure this path matches your file
                            width: 120,
                            height: 120,
                            // Optional: Match the purple theme
                            colorFilter: ColorFilter.mode(
                              Colors.purple.withOpacity(0.3),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // 2. The Text Message
                          const Text(
                            "No job posts found.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Please try again later or pull to refresh.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildJobItem(jobs[index]),
                    childCount: jobs.length,
                  ),
                );
              },
            ),

            // 3. Bottom Loader (Pagination)
            if (isFetchingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: FeatherSvgLoader(size: 30),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildJobItem(Job job) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        // 🔹 NAVIGATION ADDED HERE
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
          );
        },
        borderRadius: BorderRadius.circular(
          12,
        ), // Match the ripple effect to your card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${job.time} • ${job.company}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.favorite_border, color: Color(0xffa06cd5)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              job.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: job.tags.map((tag) => _buildTag(tag)).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      // This ensures that even if 'tag' is null, the app won't crash
      child: Text(tag ?? "", style: const TextStyle(fontSize: 12)),
    );
  }
}
