// widget/categories/category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/providers/category/cat.dart';
import '../../models/category_model.dart';
import '../companies/company_widgets.dart';

class CategoryCard extends ConsumerWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribedIds = ref.watch(categorySubscriptionProvider);
    final isSubscribed = subscribedIds.contains(category.id);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Category Name
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'pretendard',
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          /// 🔹 Description
          Text(
            category.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xff666666),
            ),
          ),

          const SizedBox(height: 14),

          /// 🔹 Metadata + Bell
          Row(
            children: [
              CompanyMetaTag(label: "${category.totalJobs} Jobs"),
              const SizedBox(width: 8),
              CompanyMetaTag(
                label:
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
            ],
          ),
        ],
      ),
    );
  }
}
