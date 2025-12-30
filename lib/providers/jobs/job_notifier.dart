import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/service/job_api.dart';
import '../../models/job.dart';

// class JobsNotifier extends AsyncNotifier<List<Job>> {
//   int _page = 1;
//   bool _isFetchingMore = false;
//   bool get isFetchingMore => _isFetchingMore;

//   @override
//   Future<List<Job>> build() async {
//     _page = 1;
//     return JobApi.fetchJobs(_page);
//   }

//   /// 🔄 Infinite Top Refresh (Prepends new jobs)
//   Future<void> refreshJobs() async {
//     try {
//       // Fetch the latest page (usually page 1)
//       final latestJobs = await JobApi.fetchJobs(1);
//       final currentJobs = state.value ?? [];

//       // 🔹 Filter out jobs we already have using their unique IDs
//       final existingIds = currentJobs.map((j) => j.id).toSet();
//       final trulyNewJobs = latestJobs
//           .where((j) => !existingIds.contains(j.id))
//           .toList();

//       // Update state: Truly new items go to the TOP, followed by everything else
//       state = AsyncData([...trulyNewJobs, ...currentJobs]);

//       // We don't necessarily reset _page to 1 here because the user
//       // might still be at the bottom of a long list they've already paged through.
//     } catch (e, stack) {
//       state = AsyncError(e, stack);
//     }
//   }

//   Future<void> fetchMoreJobs() async {
//     if (_isFetchingMore || state.isLoading) return;

//     _isFetchingMore = true;
//     ref.notifyListeners(); // Tells the UI to show the bottom loader

//     try {
//       final nextPage = _page + 1;
//       final olderJobs = await JobApi.fetchJobs(nextPage);

//       if (olderJobs.isNotEmpty) {
//         _page = nextPage;
//         final currentJobs = state.value ?? [];

//         // Create a Set of existing IDs to ensure no duplicates
//         final existingIds = currentJobs.map((j) => j.id).toSet();

//         // Filter the incoming jobs (like the Product Designer job)
//         final filteredOlder = olderJobs
//             .where((j) => !existingIds.contains(j.id))
//             .toList();

//         // IMPORTANT: This triggers the UI rebuild with the new list
//         state = AsyncData([...currentJobs, ...filteredOlder]);
//       }
//     } catch (e) {
//       debugPrint("Pagination Error: $e");
//     } finally {
//       _isFetchingMore = false;
//       ref.notifyListeners(); // Tells the UI to hide the bottom loader
//     }
//   }

//   //bool get isFetchingMore => _isFetchingMore;
// }
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
