// screens/categories/category_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/category_model.dart';
import 'package:sheqlee/professional/providers/category/category_jobs_provider.dart'
    show categoryJobsProvider;
import 'package:sheqlee/professional/widget/general_reusable/resizesable_sliver_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/professional/widget/home/job_card.dart';

// local state for the bell icon
final isSubscribedProvider = StateProvider.family<bool, String>(
  (ref, categoryId) => false,
);

class CategoryDetailsScreen extends ConsumerWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryDataAsync = ref.watch(categoryJobsProvider(category.slug));
    final isSubscribed = ref.watch(isSubscribedProvider(category.id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        // 'primary: true' lets the Scrollbar find this scroll view automatically
        primary: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          /// 🔙 Reusable Dynamic Header
          SliverPersistentHeader(
            pinned: true,
            delegate: DynamicSliverHeader(title: 'Details', showSearch: false),
          ),

          /// 📄 Main Content (Metadata and Description)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Header with local state Bell Icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 22, // Slightly larger for detail view
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            ref
                                    .read(
                                      isSubscribedProvider(
                                        category.id,
                                      ).notifier,
                                    )
                                    .state =
                                !isSubscribed,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            isSubscribed
                                ? 'assets/icons/bell-ring-solid.svg'
                                : 'assets/icons/bell-ring-outline.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              isSubscribed
                                  ? const Color(0xffa06cd5)
                                  : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Meta Data
                  categoryDataAsync.when(
                    data: (result) => Row(
                      children: [
                        _buildPill("${result.total} Jobs"),
                        const SizedBox(width: 10),
                        _buildPill("${category.totalSubscribers} Subs"),
                      ],
                    ),
                    loading: () => const SizedBox(height: 20),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xff555555),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Open Positions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),
                ],
              ),
            ),
          ),

          /// 🔹 Job Cards List
          categoryDataAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffa06cd5)),
              ),
            ),
            error: (err, _) => SliverToBoxAdapter(
              child: Center(child: Text('Error loading jobs: $err')),
            ),
            data: (result) {
              if (result.jobs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No jobs found.")),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: JobCard(job: result.jobs[index]),
                    ),
                    childCount: result.jobs.length,
                  ),
                ),
              );
            },
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // Consistent Pill design
  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fa),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffeeeeee)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
