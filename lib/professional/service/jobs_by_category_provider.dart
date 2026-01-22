import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/category_model.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/service/job_api.dart';

// service/jobs_by_category_provider.dart
// service/jobs_by_category_provider.dart

// service/jobs_by_category_provider.dart

// service/jobs_by_category_provider.dart

final jobsByCategoryProvider = FutureProvider.family<List<Job>, Category>((
  ref,
  category,
) async {
  try {
    // We use category.slug because your backend controller does:
    // JobCategory.findOne({ slug: req.query.category })
    final jobs = await JobApi.fetchJobs(
      1, // First page
      categoryId:
          category.slug, // This maps to queryParams['category'] in your JobApi
    );

    return jobs;
  } catch (e) {
    debugPrint("JobsByCategoryProvider Error: $e");
    // Returning an empty list prevents the "Cannot send Null" crash
    return [];
  }
});
