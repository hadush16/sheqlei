import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart';
import 'package:sheqlee/screens/home/filter_page.dart';
import 'package:sheqlee/screens/home/job_details_screen.dart';
import 'package:sheqlee/widget/app_sliver_header.dart';
import 'package:sheqlee/widget/favotite_icon.dart';
import 'package:sheqlee/widget/job_metadata_section.dart';
import 'package:sheqlee/widget/job_shimmer_loading.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/providers/jobs/job_notifier.dart';
import 'package:sheqlee/models/job_type_model.dart';
import 'package:sheqlee/models/job_level_model.dart';

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
    // If we are 200 pixels from the bottom, trigger the fetch
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
    // final isFetchingMore = ref.watch(jobsProvider.notifier).isFetchingMore;
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
        padding: const EdgeInsets.only(top: 20),
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
                      (context, index) => _buildJobItem(jobs[index]),
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

  Widget _buildJobItem(Job job) {
    final allTypes = ref.watch(jobTypesProvider).value ?? [];
    final allLevels = ref.watch(jobLevelsProvider).value ?? [];

    // 2. RESOLVE the IDs to full names
    // We search the list for a match; if not found, we show nothing
    final String typeName = allTypes
        .firstWhere(
          (t) => t.id == job.typeId,
          orElse: () => JobType(id: '', name: ''),
        )
        .name;

    final String levelName = allLevels
        .firstWhere(
          (l) => l.id == job.levelId,
          orElse: () => JobLevel(id: '', name: ''),
        )
        .name;

    // 3. Prepare the display list (Only including non-empty strings)
    final List<String> displayTags = [
      if (typeName.isNotEmpty) typeName,
      if (levelName.isNotEmpty) levelName,
      if (job.salary.isNotEmpty) job.salary,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time and Company (Optional info)
            Text(
              "${job.time} ",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),

            // 2. Job Title
            Text(
              job.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // 3. Short Description
            Text(
              job.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // 4. THE ROW: Dynamic Tags (Type, Level, Salary) + Favorite Icon
            // This is now positioned BELOW the description as requested
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: JobMetadataSection(job: job, showRocketIcon: false),
                ),
                FavoriteButton(jobId: job.id),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
          ],
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
                Colors.purple.withOpacity(0.3),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No job posts found.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
