import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/providers/jobs/job_notifier.dart';

// 1. The existing ID tracker
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String jobId) {
    if (state.contains(jobId)) {
      state = {...state}..remove(jobId);
    } else {
      state = {...state}..add(jobId);
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier();
  },
);

// 2. NEW: The Filtered Jobs List Provider
final favoritedJobsProvider = Provider<List<Job>>((ref) {
  final allJobs = ref.watch(jobsProvider).value ?? [];
  final favoriteIds = ref.watch(favoritesProvider);

  // Return only jobs whose ID exists in the favorites set
  return allJobs.where((job) => favoriteIds.contains(job.id)).toList();
});
