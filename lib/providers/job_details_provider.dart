import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job.dart';
import 'package:sheqlee/providers/job_notifier.dart';

final jobDetailsProvider = Provider.family<Job?, int>((ref, index) {
  final jobsState = ref.watch(jobsProvider);

  return jobsState.when(
    data: (jobs) => index < jobs.length ? jobs[index] : null,
    loading: () => null,
    error: (_, __) => null,
  );
});
