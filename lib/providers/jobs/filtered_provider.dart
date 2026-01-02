// New provider for the Filtered Results Screen
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/providers/filter_provider.dart';
import 'package:sheqlee/service/job_api.dart';

class FilteredJobsNotifier extends AsyncNotifier<List<Job>> {
  int _page = 1;
  bool _isFetchingMore = false;
  bool get isFetchingMore => _isFetchingMore;

  @override
  Future<List<Job>> build() async {
    // Watch the filter state to trigger re-fetches
    final filterState = ref.watch(filterSearchProvider);
    _page = 1;

    // Call the API with the current filter state
    return await JobApi.fetchJobs(
      _page,
      query: filterState.searchQuery,
      tagId: filterState.activeTagId,
      categoryId: filterState.activeCategoryId,
    );
  }

  Future<void> fetchMore() async {
    if (_isFetchingMore || state.isLoading) return;

    final filterState = ref.read(filterSearchProvider);
    _isFetchingMore = true;
    ref.notifyListeners();

    try {
      final nextPage = _page + 1;
      final olderJobs = await JobApi.fetchJobs(
        nextPage,
        query: filterState.searchQuery,
        tagId: filterState.activeTagId,
        categoryId: filterState.activeCategoryId,
      );

      if (olderJobs.isNotEmpty) {
        _page = nextPage;
        final currentJobs = state.value ?? [];
        state = AsyncData([...currentJobs, ...olderJobs]);
      }
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
