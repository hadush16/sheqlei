import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/category_model.dart';
//import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/service/job_api.dart'; // Adjust this to your model path

final jobCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  // We use 'async' to wrap the list in a Future automatically.
  // This simulates a network call and fixes the 'invalid_type_from_closure' error.

  // Optional: Add a tiny delay to see your loading shimmer/spinner
  await Future.delayed(const Duration(milliseconds: 200));

  return await JobApi.fetchCategories();
});

// Provider to get a specific category's job count
final categoryJobsProvider = Provider.family<int, String>((ref, categoryId) {
  final categoriesAsync = ref.watch(jobCategoriesProvider);
  return categoriesAsync.maybeWhen(
    data: (categories) => categories
        .firstWhere(
          (c) => c.id == categoryId,
          // FIX: Add required named parameters here
          orElse: () => Category(
            id: '',
            name: '',
            slug: '',
            description: '',
            totalJobs: 0,
            totalSubscribers: 0,
          ),
        )
        .totalJobs, // Updated from jobsCount to totalJobs to match your model
    orElse: () => 0,
  );
});

// Provider to get a specific category's subscriber count
final categorySubsProvider = Provider.family<int, String>((ref, categoryId) {
  final categoriesAsync = ref.watch(jobCategoriesProvider);
  return categoriesAsync.maybeWhen(
    data: (categories) => categories
        .firstWhere(
          (c) => c.id == categoryId,
          // FIX: Add required named parameters here
          orElse: () => Category(
            id: '',
            name: '',
            slug: '',
            description: '',
            totalJobs: 0,
            totalSubscribers: 0,
          ),
        )
        .totalSubscribers, // Updated from subsCount to totalSubscribers
    orElse: () => 0,
  );
});
