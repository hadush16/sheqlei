// widget/categories/category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/professional/providers/category/category_jobs_provider.dart';
import 'package:sheqlee/professional/providers/category/category_provider.dart'
    hide categoryJobsProvider;
import '../../../professional/models/category_model.dart';

// class CategoryCard extends ConsumerWidget {
//   final Category category;
//   final VoidCallback onTap;

//   const CategoryCard({super.key, required this.category, required this.onTap});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final subscribedIds = ref.watch(categorySubscriptionProvider);
//     final isSubscribed = subscribedIds.contains(category.id);
//     final jobData = ref.watch(categoryJobsProvider(category.slug));
//     final totalJobs = jobData.maybeWhen(
//       data: (result) => result.total,
//       orElse: () => category.totalJobs, // Fallback to initial value (even if 0)
//     );

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: const BoxDecoration(
//           border: Border(bottom: BorderSide(color: Colors.black12)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔹 Category Name
//             Text(
//               category.name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'pretendard',
//                 color: Colors.black,
//               ),
//             ),

//             const SizedBox(height: 6),

//             /// 🔹 Description
//             Text(
//               category.description,
//               style: const TextStyle(
//                 fontSize: 13,
//                 height: 1.4,
//                 color: Color(0xff666666),
//               ),
//             ),

//             const SizedBox(height: 14),

//             /// 🔹 Metadata + Bell
//             // Row(
//             //   children: [
//             //     CompanyMetaTag(label: "${category.totalJobs} Jobs"),
//             //     const SizedBox(width: 8),
//             //     CompanyMetaTag(
//             //       label:
//             //           "${category.totalSubscribers + (isSubscribed ? 1 : 0)} Subs",
//             //     ),
//             //     const Spacer(),

//             //     /// 🔔 Subscribe Bell
//             //     GestureDetector(
//             //       onTap: () => ref
//             //           .read(categorySubscriptionProvider.notifier)
//             //           .toggle(category.id),
//             //       child: SvgPicture.asset(
//             //         isSubscribed
//             //             ? 'assets/icons/bell-ring-solid.svg'
//             //             : 'assets/icons/bell-ring-outline.svg',
//             //         width: 20,
//             //         colorFilter: const ColorFilter.mode(
//             //           Color(0xffa06cd5),
//             //           BlendMode.srcIn,
//             //         ),
//             //       ),
//             //     ),
//             //     SizedBox(width: 6),
//             //   ],
//             // ),
//             Row(
//               children: [
//                 /// 🛠️ Direct Replacement for Category Meta (Jobs)
//                 _buildCustomMeta(
//                   "${category.totalJobs} Jobs",
//                 ), // Uses the fixed model field
//                 const SizedBox(width: 8),
//                 _buildCustomMeta(
//                   "${category.totalSubscribers + (isSubscribed ? 1 : 0)} Subs",
//                 ),
//                 const Spacer(),

//                 /// 🔔 Subscribe Bell
//                 GestureDetector(
//                   onTap: () => ref
//                       .read(categorySubscriptionProvider.notifier)
//                       .toggle(category.id),
//                   child: SvgPicture.asset(
//                     isSubscribed
//                         ? 'assets/icons/bell-ring-solid.svg'
//                         : 'assets/icons/bell-ring-outline.svg',
//                     width: 20,
//                     colorFilter: const ColorFilter.mode(
//                       Color(0xffa06cd5),
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Custom Meta tag designed specifically for Categories
//   Widget _buildCustomMeta(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xffF1F1F1), // Clean light grey
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           color: Color(0xff666666),
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

// widget/categories/category_card.dart
class CategoryCard extends ConsumerWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Properly watch the provider
    final jobDataAsync = ref.watch(categoryJobsProvider(category.slug));

    final subscribedIds = ref.watch(categorySubscriptionProvider);
    final isSubscribed = subscribedIds.contains(category.id);

    // 2. Get the count safely from the AsyncValue
    final String displayJobs = jobDataAsync.when(
      data: (result) => "${result.total} Jobs",
      loading: () => "... Jobs",
      error: (_, __) => "${category.totalJobs} Jobs", // Fallback to model
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              category.description,
              style: const TextStyle(fontSize: 13, color: Color(0xff666666)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                /// 🔹 Dynamic Jobs Count
                _buildCategoryMeta(displayJobs),

                const SizedBox(width: 8),

                /// 🔹 Dynamic Subs Count
                _buildCategoryMeta(
                  "${category.totalSubscribers + (isSubscribed ? 1 : 0)} Subs",
                ),

                const Spacer(),

                /// 🔔 Subscribe Bell
                GestureDetector(
                  onTap: () => ref
                      .read(categorySubscriptionProvider.notifier)
                      .toggle(category.id),
                  child: SvgPicture.asset(
                    isSubscribed
                        ? 'assets/icons/bell-ring-solid.svg'
                        : 'assets/icons/bell-ring-outline.svg',
                    width: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xffa06cd5),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                // Small extra padding to ensure the bell isn't flush against the scrollbar
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryMeta(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Color(0xff666666)),
      ),
    );
  }
}
