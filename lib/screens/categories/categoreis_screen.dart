import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/category/category_provider.dart';
import 'package:sheqlee/widget/categories/reusable_categories_card.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the specific provider you created
    final categoriesAsync = ref.watch(jobCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🔹 Header
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
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'pretendard',
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Category List
          Positioned(
            top: 140,
            left: 25,
            right: 25,
            bottom: 0,
            child: categoriesAsync.when(
              // 2. Handle Loading State
              loading: () => const Center(child: CircularProgressIndicator()),

              // 3. Handle Error State
              error: (err, stack) => Center(
                child: Text(
                  'Failed to load categories: $err',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ),

              // 4. Handle Data State
              data: (categories) => RefreshIndicator(
                // To refresh a FutureProvider, use ref.invalidate()
                onRefresh: () async => ref.invalidate(jobCategoriesProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(category: category);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
