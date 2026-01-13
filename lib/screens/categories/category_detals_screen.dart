// screens/categories/category_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/category_model.dart';
import 'package:sheqlee/service/jobs_by_category_provider.dart';
import 'package:sheqlee/widget/home/job_card.dart';
import '../../widget/companies/company_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryDetailsScreen extends ConsumerWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsByCategoryProvider(category.id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🔙 Back + Title
          Positioned(
            left: 25,
            top: 89,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'pretendard',
                  ),
                ),
              ],
            ),
          ),

          /// 📄 Content
          Positioned(
            top: 140,
            left: 25,
            right: 25,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Title + Bell
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/bell-ring-outline.svg',
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xffa06cd5),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 Meta
                  Row(
                    children: [
                      CompanyMetaTag(label: "${category.totalJobs} Jobs"),
                      const SizedBox(width: 8),
                      CompanyMetaTag(
                        label: "${category.totalSubscribers} Subs",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 Description
                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xff555555),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // _TagChip('Flutter'),
                      // _TagChip('React Native'),
                      // _TagChip('Ionic'),
                      // _TagChip('Xamarin'),
                      // _TagChip('PhoneGap'),
                      // _TagChip('Cordova'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// 🔹 Jobs List
                  jobsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text(
                      'Failed to load jobs',
                      style: TextStyle(color: Colors.red),
                    ),
                    data: (jobs) => Column(
                      children: jobs.map((job) => JobCard(job: job)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
