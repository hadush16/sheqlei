import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/providers/jobs/job_notifier.dart';

// This class stores the current selection state
class JobFilterState {
  final String? categoryId;
  final String? typeId;
  final String? levelId;
  final bool isApplied;

  JobFilterState({
    this.categoryId,
    this.typeId,
    this.levelId,
    this.isApplied = false,
  });

  JobFilterState copyWith({
    String? categoryId,
    String? typeId,
    String? levelId,
    bool? isApplied,
  }) {
    return JobFilterState(
      categoryId: categoryId ?? this.categoryId,
      typeId: typeId ?? this.typeId,
      levelId: levelId ?? this.levelId,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}

// 1. Provider to hold the SELECTED filter criteria
final jobFilterCriteriaProvider = StateProvider<JobFilterState>(
  (ref) => JobFilterState(),
);

// 2. The separate provider that performs the actual filtering
final searchResultProvider = Provider<List<Job>>((ref) {
  final allJobsAsync = ref.watch(jobsProvider); // Your existing JobsNotifier
  final criteria = ref.watch(jobFilterCriteriaProvider);

  // If the user hasn't pressed apply yet, return an empty list
  if (!criteria.isApplied) return [];

  return allJobsAsync.maybeWhen(
    data: (jobs) {
      return jobs.where((job) {
        // Match Category ID
        final matchesCategory =
            criteria.categoryId == null ||
            job.categoryId == criteria.categoryId;

        // Match Job Type ID
        final matchesType =
            criteria.typeId == null || job.typeId == criteria.typeId;

        // Match Job Level ID
        final matchesLevel =
            criteria.levelId == null || job.levelId == criteria.levelId;

        return matchesCategory && matchesType && matchesLevel;
      }).toList();
    },
    orElse: () => [],
  );
});
