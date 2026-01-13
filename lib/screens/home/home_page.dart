import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_svg/svg.dart';

import 'package:sheqlee/providers/jobs/job_notifier.dart';
import 'package:sheqlee/providers/user/user_provider.dart';
import 'package:sheqlee/screens/fitter/filter_page.dart';
import 'package:sheqlee/screens/profile/app_drawer.dart';
import 'package:sheqlee/widget/home/app_fab.dart';
import 'package:sheqlee/widget/home/app_sliver_header.dart';
import 'package:sheqlee/widget/home/empty_job_widget.dart';
import 'package:sheqlee/widget/home/job_card.dart';
import 'package:sheqlee/widget/home/job_shimmer_loading.dart';

class HomePage extends ConsumerStatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  IndicatorController? _refreshController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final userAsync = ref.watch(userProvider);

    // 2. EXTRACT USERNAME SAFELY
    final String currentUsername = userAsync.when(
      data: (user) => user?.name ?? "Muruts Yifter",
      loading: () => "Loading...",
      error: (_, __) => "Error",
    );
    final bool showFab = jobsAsync.maybeWhen(
      data: (jobs) => jobs.isNotEmpty,
      orElse: () => false,
    );

    return GestureDetector(
      onTap: () {
        // We use Scaffold.of(context) inside this Builder
        // If your drawer is on the left, use openDrawer()
        // If your drawer is on the right, use openEndDrawer()
        Scaffold.of(context).openDrawer();
      },
      child: Scaffold(
        key: _scaffoldKey, // 2. ASSIGN THE KEY
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        //drawer: const AppDrawer(),
        floatingActionButton: AppFloatingActionButton(
          isVisible: showFab,
          heroTag: "home_fab",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            );
          },
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
                AppSliverHeader(scaffoldKey: _scaffoldKey),
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
                    hasScrollBody: true,
                    //child: Center(child: JobShimmerLoading()),
                    // child: Center(child: FeatherSvgLoader(size: 40)),
                  ),
                  // error: (err, stack) => SliverToBoxAdapter(
                  //   child: Center(child: Text("Error: $err")),
                  // ),
                  error: (err, stack) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmptyStateWidget(), // Reusing your empty widget
                        const SizedBox(height: 10),
                        const Text("Slow connection detected."),
                      ],
                    ),
                  ),
                  data: (jobs) {
                    // FIX: If jobs are empty, return the EmptyStateWidget inside a Sliver
                    if (jobs.isEmpty) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyStateWidget(),
                      );
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
      ),
    );
  }
}
