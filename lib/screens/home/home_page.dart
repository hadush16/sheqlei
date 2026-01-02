import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sheqlee/providers/jobs/job_notifier.dart';
import 'package:sheqlee/screens/home/filter_page.dart';
import 'package:sheqlee/widget/app_sliver_header.dart';
import 'package:sheqlee/widget/job_card.dart';
import 'package:sheqlee/widget/job_shimmer_loading.dart';

class HomePage extends ConsumerStatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  IndicatorController? _refreshController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(jobsProvider.notifier).fetchMoreJobs();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final notifier = ref.watch(jobsProvider.notifier);
    final isFetchingMore = notifier.isFetchingMore;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff8967B3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FilterScreen()),
          );
        },
        child: SvgPicture.asset(
          'assets/icons/search-alt2.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: CustomRefreshIndicator(
          onRefresh: () => ref.read(jobsProvider.notifier).refreshJobs(),
          builder: (context, child, controller) {
            _refreshController = controller;
            return Stack(
              children: [
                child,
                if (controller.value > 0)
                  Positioned(
                    top: 180,
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
              AppSliverHeader(username: widget.username),
              const SliverToBoxAdapter(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEEEEEE),
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              if (_refreshController != null)
                AnimatedBuilder(
                  animation: _refreshController!,
                  builder: (context, _) => SliverToBoxAdapter(
                    child: SizedBox(height: _refreshController!.value * 100),
                  ),
                ),
              jobsAsync.when(
                skipLoadingOnReload: true,
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  // child: Center(child: FeatherSvgLoader(size: 40)),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text("Error: $err")),
                ),
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => JobCard(
                        job: jobs[index],
                      ), // Use the reusable widget here
                      childCount: jobs.length,
                    ),
                  );
                },
              ),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/sad.svg',
              width: 120,
              height: 120,
              colorFilter: ColorFilter.mode(
                Color(0xff8967B3).withOpacity(0.3),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No job posts, \n please try again later",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff000000),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
