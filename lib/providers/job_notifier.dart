import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/service/job_api.dart';
import '../models/job.dart';

class JobsNotifier extends AsyncNotifier<List<Job>> {
  int _page = 1;
  bool _isFetchingMore = false;

  @override
  Future<List<Job>> build() async {
    _page = 1;
    return JobApi.fetchJobs(_page);
  }

  /// 🔄 Pull-to-refresh
  Future<void> refreshJobs() async {
    state = const AsyncLoading();
    _page = 1;
    state = AsyncData(await JobApi.fetchJobs(_page));
  }

  /// ⬇️ Load more (pagination)
  Future<void> loadMore() async {
    if (_isFetchingMore || state.isLoading) return;

    _isFetchingMore = true;

    final previous = state.value ?? [];
    final nextPage = _page + 1;

    try {
      final newJobs = await JobApi.fetchJobs(nextPage);
      _page = nextPage;

      state = AsyncData([...previous, ...newJobs]);
    } finally {
      _isFetchingMore = false;
    }
  }

  bool get isFetchingMore => _isFetchingMore;
}

final jobsProvider = AsyncNotifierProvider<JobsNotifier, List<Job>>(
  JobsNotifier.new,
);
