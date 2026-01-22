// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/models/job.dart';
// import 'package:sheqlee/providers/filter_provider.dart';
// import 'package:sheqlee/service/job_api.dart';

// class FilteredJobsNotifier extends AsyncNotifier<List<Job>> {
//   int _page = 1;
//   bool _isFetchingMore = false;
//   bool _hasReachedMax = false; // Added to prevent useless API calls

//   @override
//   Future<List<Job>> build() async {
//     // 1. Listen to filter changes (search, category, etc.)
//     final filterState = ref.watch(filterSearchProvider);

//     // 2. Reset pagination state when filters change
//     _page = 1;
//     _hasReachedMax = false;

//     // 3. Fetch from the real database via JobApi
//     return await JobApi.fetchJobs(
//       _page,
//       query: filterState.searchQuery,
//       // Note: Backend uses 'category' string ID
//       categoryId: filterState.activeCategoryId,
//     );
//   }

//   Future<void> fetchMore() async {
//     if (_isFetchingMore || _hasReachedMax || state.isLoading) return;

//     final filterState = ref.read(filterSearchProvider);
//     _isFetchingMore = true;

//     // Trigger UI update to show loading spinner at bottom
//     ref.notifyListeners();

//     try {
//       final nextPage = _page + 1;
//       final newJobs = await JobApi.fetchJobs(
//         nextPage,
//         query: filterState.searchQuery,
//         categoryId: filterState.activeCategoryId,
//       );

//       if (newJobs.isEmpty) {
//         _hasReachedMax = true;
//       } else {
//         _page = nextPage;
//         final currentJobs = state.value ?? [];
//         state = AsyncData([...currentJobs, ...newJobs]);
//       }
//     } catch (e, st) {
//       // Handle potential network errors
//       state = AsyncError(e, st);
//     } finally {
//       _isFetchingMore = false;
//       ref.notifyListeners();
//     }
//   }
// }

// final filteredJobsProvider =
//     AsyncNotifierProvider<FilteredJobsNotifier, List<Job>>(
//       FilteredJobsNotifier.new,
//     );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/providers/filter/job_filter_logic_provider.dart';
import 'package:sheqlee/professional/providers/filter/filter_provider.dart';
import 'package:sheqlee/professional/service/job_api.dart'; // Import your filter state provider

class FilteredJobsNotifier extends AsyncNotifier<List<Job>> {
  int _page = 1;
  bool _isFetchingMore = false;
  bool _hasReachedMax = false;

  @override
  Future<List<Job>> build() async {
    // 1. Watch the Search bar provider
    final searchState = ref.watch(filterSearchProvider);
    final criteria = ref.watch(jobFilterCriteriaProvider);

    // 2. Watch the Dropdown Filter provider (Category, Type, Level)
    // This is the one that has the 'isApplied' property

    _page = 1;
    _hasReachedMax = false;

    // 3. Combine both into the API call
    return await JobApi.fetchJobs(
      _page,
      query: searchState.searchQuery,
      categoryId: criteria.categoryId ?? searchState.activeCategoryId,
      typeId: criteria.typeId, // Sending 'full_time', etc.
      levelId: criteria.levelId, // Sending 'senior', etc.
      tagId: searchState.activeTagId,
    );
  }

  // Update fetchMore to use the same logic...
  Future<void> fetchMore() async {
    if (_isFetchingMore || _hasReachedMax || state.isLoading) return;

    final searchState = ref.read(filterSearchProvider);
    final criteria = ref.read(jobFilterCriteriaProvider);

    _isFetchingMore = true;
    try {
      final nextPage = _page + 1;
      final newJobs = await JobApi.fetchJobs(
        nextPage,
        query: searchState.searchQuery,
        categoryId: criteria.categoryId ?? searchState.activeCategoryId,
        typeId: criteria.typeId,
        levelId: criteria.levelId,
        tagId: searchState.activeTagId,
      );

      // ... existing pagination logic
      if (newJobs.isEmpty) {
        _hasReachedMax = true;
      } else {
        _page = nextPage;
        final currentJobs = state.value ?? [];
        state = AsyncData([...currentJobs, ...newJobs]);
      }
    } catch (e, st) {
      //       // Handle potential network errors
      state = AsyncError(e, st);
    } finally {
      _isFetchingMore = false;
      ref.notifyListeners();
    }
  }
}

final filteredJobsProvider =
    AsyncNotifierProvider<FilteredJobsNotifier, List<Job>>(
      FilteredJobsNotifier.new,
    );
