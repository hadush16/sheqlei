import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/category_model.dart';
import 'package:sheqlee/providers/filter_provider.dart';

class CategorySearchGroup extends ConsumerWidget {
  final List<Category> categories;

  const CategorySearchGroup({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCatId = ref.watch(filterSearchProvider).activeCategoryId;

    return ListView.builder(
      shrinkWrap: true, // Allows it to sit inside a Column
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = activeCatId == category.id;

        return ListTile(
          onTap: () {
            ref
                .read(filterSearchProvider.notifier)
                .setSearchCategory(category.id);
            // Optionally navigate back to see results
            Navigator.pop(context);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            category.name,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xffa06cd5) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isSelected ? const Color(0xffa06cd5) : Colors.black54,
          ),
        );
      },
    );
  }
}
