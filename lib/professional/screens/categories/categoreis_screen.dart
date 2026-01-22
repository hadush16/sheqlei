import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/providers/category/category_provider.dart';
import 'package:sheqlee/professional/screens/categories/category_detals_screen.dart';
import 'package:sheqlee/professional/widget/categories/reusable_categories_card.dart';
import 'package:sheqlee/professional/widget/general_reusable/resizesable_sliver_appbar.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(jobCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // CustomScrollView is required for SliverPersistentHeader to work
      body: CustomScrollView(
        slivers: [
          /// 🔹 Reusable Dynamic Header
          SliverPersistentHeader(
            pinned: true, // Keeps the header visible when collapsed
            delegate: DynamicSliverHeader(
              title: 'Categories',
              showSearch: false, // Set to true if you want the search icon
            ),
          ),

          /// 🔹 Category List
          categoriesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
            data: (categories) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return CategoryCard(
                    category: categories[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryDetailsScreen(category: categories[index]),
                      ),
                    ),
                  );
                }, childCount: categories.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
