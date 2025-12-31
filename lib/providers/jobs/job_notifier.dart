import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/service/job_api.dart';
import '../../models/job.dart';

class JobsNotifier extends AsyncNotifier<List<Job>> {
  int _page = 1;
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  @override
  Future<List<Job>> build() async {
    _page = 1;
    return await JobApi.fetchJobs(_page);
  }

  Future<void> refreshJobs() async {
    try {
      final latestJobs = await JobApi.fetchJobs(1);
      _page = 1; // Reset page count on manual refresh
      state = AsyncData(latestJobs);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> fetchMoreJobs() async {
    // 1. Prevent double-fetching
    if (_isFetchingMore || state.isLoading) return;

    _isFetchingMore = true;
    ref.notifyListeners(); // 🔹 Alerts the UI to show the bottom loader

    try {
      final nextPage = _page + 1;
      final olderJobs = await JobApi.fetchJobs(nextPage);

      if (olderJobs.isNotEmpty) {
        final currentJobs = state.value ?? [];

        // 2. Prevent Duplicates
        final existingIds = currentJobs.map((j) => j.id).toSet();
        final filteredOlder = olderJobs
            .where((j) => !existingIds.contains(j.id))
            .toList();

        _page = nextPage;
        // 3. Update State: This triggers the SliverList to display new items
        state = AsyncData([...currentJobs, ...filteredOlder]);
      }
    } catch (e) {
      debugPrint("Pagination Error: $e");
    } finally {
      _isFetchingMore = false;
      ref.notifyListeners(); // 🔹 Alerts the UI to hide the bottom loader
    }
  }
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(
  JobsNotifier.new,
);
