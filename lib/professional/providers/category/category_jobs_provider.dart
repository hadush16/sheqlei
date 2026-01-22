// lib/providers/category_jobs_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/category_job_response.dart';
import 'package:sheqlee/core/network/network_provider.dart';
import 'package:sheqlee/professional/service/category_details_api.dart';
// Import your dioProvider location

final categoryDetailsApiProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  return CategoryDetailsApi(client);
});

final categoryJobsProvider = FutureProvider.family<CategoryJobResponse, String>(
  (ref, slug) async {
    final api = ref.read(categoryDetailsApiProvider);
    return await api.getJobsByCategory(slug);
  },
);
