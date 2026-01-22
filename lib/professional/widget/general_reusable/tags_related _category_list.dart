import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tags_provider_for_details%20screen.dart';

class TagRelatedCategoryList extends ConsumerWidget {
  final Tag tag;

  const TagRelatedCategoryList({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider we created above
    final categories = ref.watch(tagCategoriesProvider(tag));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: 38, // Adjusted height for the chips
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final categoryName = categories[index] is Map
                  ? categories[index]['name']
                  : categories[index].name;

              return Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xffD1D5DB).withOpacity(0.9),
                    width: 2,
                  ),
                ),
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xffa06cd5),
                    fontFamily: 'pretendard', // Using your purple brand color
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
