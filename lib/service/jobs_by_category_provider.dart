import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/job.dart';
import '../../service/job_api.dart';

final jobsByCategoryProvider = FutureProvider.family<List<Job>, String>((
  ref,
  categoryId,
) {
  return JobApi.fetchJobs(
    1, // first page
    categoryId: categoryId, // ✅ reuse existing logic
  );
});
