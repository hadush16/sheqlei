import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/service/job_api.dart';
import '../../models/job.dart';

class JobsNotifier extends AsyncNotifier<List<Job>> {
  int _page = 1;
  bool _isFetchingMore = false;

  @override
  Future<List<Job>> build() async {
    _page = 1;
    return JobApi.fetchJobs(_page);
  }

  /// 🔄 Infinite Top Refresh (Prepends new jobs)
  Future<void> refreshJobs() async {
    try {
      // Fetch the latest page (usually page 1)
      final latestJobs = await JobApi.fetchJobs(1);
      final currentJobs = state.value ?? [];

      // 🔹 Filter out jobs we already have using their unique IDs
      final existingIds = currentJobs.map((j) => j.id).toSet();
      final trulyNewJobs = latestJobs
          .where((j) => !existingIds.contains(j.id))
          .toList();

      // Update state: Truly new items go to the TOP, followed by everything else
      state = AsyncData([...trulyNewJobs, ...currentJobs]);

      // We don't necessarily reset _page to 1 here because the user
      // might still be at the bottom of a long list they've already paged through.
    } catch (e) {
      // Optional: Handle error without destroying existing list
      // state = AsyncError(e, st);
    }
  }

  /// ⬇️ Infinite Bottom Load (Appends older jobs)
  /// Renamed to match your HomePage's scroll listener call
  Future<void> fetchMoreJobs() async {
    if (_isFetchingMore || state.isLoading) return;

    _isFetchingMore = true;

    // 🔹 Notify listeners so the UI's 'isFetchingMore' check updates immediately
    ref.notifyListeners();

    final previousJobs = state.value ?? [];
    final nextPage = _page + 1;

    try {
      final olderJobs = await JobApi.fetchJobs(nextPage);

      if (olderJobs.isNotEmpty) {
        _page = nextPage;

        // 🔹 Prevent duplicates here as well, just in case
        final existingIds = previousJobs.map((j) => j.id).toSet();
        final filteredOlder = olderJobs
            .where((j) => !existingIds.contains(j.id))
            .toList();

        state = AsyncData([...previousJobs, ...filteredOlder]);
      }
    } catch (e) {
      // Handle pagination error (e.g., show a snackbar)
    } finally {
      _isFetchingMore = false;
      ref.notifyListeners();
    }
  }

  bool get isFetchingMore => _isFetchingMore;
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(
  JobsNotifier.new,
);
