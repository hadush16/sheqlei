import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/service/job_api.dart';
import 'package:sheqlee/professional/providers/filter/filter_provider.dart';

// This provider handles ONLY searching by Tags
final tagFilteredJobsProvider = FutureProvider.autoDispose<List<Job>>((
  ref,
) async {
  final searchState = ref.watch(filterSearchProvider);

  if (searchState.activeTagId == null) return [];

  // If your backend isn't finding jobs by ID, try sending the Query/Name instead
  // Sometimes backends expect the tag name in the 'q' or 'query' parameter
  return await JobApi.searchJobs(
    tagId: searchState.activeTagId, // This is the ID
    query: searchState.searchQuery, // This might be the name
  );
});
