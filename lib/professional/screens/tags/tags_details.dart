// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/core/network/dio_client.dart';
// import 'package:sheqlee/models/tag_model.dart';
// import 'package:sheqlee/widget/general_reusable/resizesable_sliver_appbar.dart';
// import 'package:sheqlee/widget/home/job_card.dart';

// // Define this locally so you don't have to touch your tags_provider.dart
// final jobsByTagProvider = FutureProvider.family<List<dynamic>, String>((
//   ref,
//   tagId,
// ) async {
//   final dio = ref.watch(dioProvider);

//   try {
//     // We send the tagId to your backend controller's req.query.tags
//     final response = await dio.get('/jobs', queryParameters: {'tags': tagId});

//     if (response.data != null && response.data['data'] != null) {
//       return response.data['data']['jobs'] as List<dynamic>;
//     }
//     return [];
//   } on DioException catch (e) {
//     // If backend returns 404 (No matching tags found), return empty list
//     if (e.response?.statusCode == 404) {
//       return [];
//     }
//     rethrow; // For other serious errors
//   }
// });

// class TagDetailScreen extends ConsumerWidget {
//   final Tag tag; // We use the Tag class to avoid the NoSuchMethodError

//   const TagDetailScreen({super.key, required this.tag});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Accessing the provider using the object property .id
//     final jobsAsync = ref.watch(jobsByTagProvider(tag.id));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           // Row 0: Reusable Header (Search hidden)
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: DynamicSliverHeader(title: tag.name, showSearch: false),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ROW 1: Name, Logo, and Subscribe Icon
//                   Row(
//                     children: [
//                       Text(
//                         tag.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Icon(
//                         Icons.auto_awesome,
//                         color: Colors.deepPurple,
//                         size: 20,
//                       ), // Tag Logo
//                       const Spacer(),
//                       const Icon(
//                         Icons.notifications_none,
//                         color: Color(0xffa06cd5),
//                         size: 28,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // ROW 2: Total Jobs and Total Subscribers
//                   Row(
//                     children: [
//                       _buildStatPill("${tag.totalJobs} Jobs"),
//                       const SizedBox(width: 12),
//                       _buildStatPill("${tag.totalSubscribers} Subscribers"),
//                     ],
//                   ),
//                   const SizedBox(height: 25),

//                   // ROW 3: Description
//                   const Text(
//                     "Description",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     tag.description,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       height: 1.5,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 25),

//                   // ROW 4: List of Categories (In a row)
//                   const Text(
//                     "Related Categories",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   if (tag.categories != null && tag.categories!.isNotEmpty)
//                     SizedBox(
//                       height: 40,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: tag.categories!.length,
//                         itemBuilder: (context, index) {
//                           return _buildCategoryChip(
//                             tag.categories![index].name,
//                           );
//                         },
//                       ),
//                     )
//                   else
//                     const Text(
//                       "No related categories",
//                       style: TextStyle(color: Colors.grey),
//                     ),

//                   const SizedBox(height: 30),
//                   const Text(
//                     "Available Jobs",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const Divider(height: 30),
//                 ],
//               ),
//             ),
//           ),

//           // LIST: Reusing your JobCard for the filtered results
//           jobsAsync.when(
//             data: (jobs) {
//               if (jobs.isEmpty) {
//                 return const SliverFillRemaining(
//                   child: Center(child: Text("No jobs found for this tag.")),
//                 );
//               }
//               return SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) => JobCard(job: jobs[index]),
//                   childCount: jobs.length,
//                 ),
//               );
//             },
//             loading: () => const SliverToBoxAdapter(
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (err, stack) => SliverFillRemaining(
//               child: Center(child: Text("Error: Unable to fetch jobs.")),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper widget for Row 2
//   Widget _buildStatPill(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xffF8F9FB),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color(0xffE5E7EB)),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: Colors.black87,
//         ),
//       ),
//     );
//   }

//   // Helper widget for Row 4
//   Widget _buildCategoryChip(String name) {
//     return Container(
//       margin: const EdgeInsets.only(right: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xffEEEEEE)),
//       ),
//       child: Text(
//         name,
//         style: const TextStyle(fontSize: 13, color: Colors.black54),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/models/tag_model.dart';
// import 'package:sheqlee/providers/tags/tags_provider_for_details%20screen.dart';
// import 'package:sheqlee/widget/companies/company_widgets.dart';
// import 'package:sheqlee/widget/general_reusable/resizesable_sliver_appbar.dart';
// import 'package:sheqlee/widget/home/job_card.dart';

// class TagDetailScreen extends ConsumerWidget {
//   final Tag tag;

//   const TagDetailScreen({super.key, required this.tag});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final statsAsync = ref.watch(tagStatsProvider(tag.id));
//     final jobsAsync = ref.watch(jobsByTagProvider(tag.id));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomScrollView(
//         slivers: [
//           // HEADER: Reusing your DynamicSliverHeader
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: DynamicSliverHeader(title: "Details", showSearch: false),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // NAME & BELL
//                   Row(
//                     children: [
//                       Text(
//                         tag.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       const Icon(
//                         Icons.notifications_none,
//                         color: Color(0xffa06cd5),
//                         size: 28,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),

//                   // STATS: Reusing CompanyMetaTag with fallback logic
//                   statsAsync.when(
//                     data: (stats) => Row(
//                       children: [
//                         CompanyMetaTag(label: stats['jobs']!), //
//                         const SizedBox(width: 8),
//                         CompanyMetaTag(label: stats['subs']!), //
//                       ],
//                     ),
//                     loading: () => const CircularProgressIndicator(),
//                     error: (_, __) => Row(
//                       children: [
//                         const CompanyMetaTag(label: "89 Jobs"),
//                         const SizedBox(width: 8),
//                         const CompanyMetaTag(label: "1780 Subs"),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 25),

//                   // DESCRIPTION
//                   const Text(
//                     "Description",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     tag.description,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       height: 1.5,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   const Text(
//                     "Available Jobs",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const Divider(height: 30),
//                 ],
//               ),
//             ),
//           ),

//           // JOBS LIST: Reusing JobCard
//           jobsAsync.when(
//             data: (jobs) {
//               if (jobs.isEmpty) {
//                 return const SliverFillRemaining(
//                   child: Center(child: Text("No current openings.")),
//                 );
//               }
//               return SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 sliver: SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: JobCard(job: jobs[index]), //
//                     ),
//                     childCount: jobs.length,
//                   ),
//                 ),
//               );
//             },
//             loading: () => const SliverToBoxAdapter(
//               child: Center(child: CircularProgressIndicator()),
//             ),
//             error: (err, _) => SliverToBoxAdapter(
//               child: Center(child: Text("Error syncing jobs")),
//             ),
//           ),

//           const SliverToBoxAdapter(child: SizedBox(height: 40)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tags_provider_for_details%20screen.dart';
import 'package:sheqlee/professional/widget/companies/company_widgets.dart';
import 'package:sheqlee/professional/widget/general_reusable/resizesable_sliver_appbar.dart';
import 'package:sheqlee/professional/widget/home/job_card.dart';
import 'package:sheqlee/professional/widget/subscription/subscription.dart';

import '../../widget/general_reusable/tags_related _category_list.dart';

class TagDetailScreen extends ConsumerWidget {
  final Tag tag;

  const TagDetailScreen({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(tagStatsProvider(tag.id));
    final jobsAsync = ref.watch(jobsByTagProvider(tag.id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // HEADER: Reusing your DynamicSliverHeader
          SliverPersistentHeader(
            pinned: true,
            delegate: DynamicSliverHeader(title: "Details", showSearch: false),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME & BELL
                  Row(
                    children: [
                      Text(
                        tag.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      AppSubscribeBell(id: tag.id, type: 'tag', size: 24),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // STATS: Reusing CompanyMetaTag with fallback logic
                  statsAsync.when(
                    data: (stats) => Row(
                      children: [
                        CompanyMetaTag(label: stats['jobs']!), //
                        const SizedBox(width: 8),
                        CompanyMetaTag(label: stats['subs']!), //
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => Row(
                      children: [
                        const CompanyMetaTag(label: "89 Jobs"),
                        const SizedBox(width: 8),
                        const CompanyMetaTag(label: "1780 Subs"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // DESCRIPTION
                  const SizedBox(height: 8),
                  Text(
                    tag.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  TagRelatedCategoryList(tag: tag),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // JOBS LIST: Reusing JobCard
          jobsAsync.when(
            data: (jobs) {
              if (jobs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No current openings.")),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: JobCard(job: jobs[index]), //
                    ),
                    childCount: jobs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => SliverToBoxAdapter(
              child: Center(child: Text("Error syncing jobs")),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
