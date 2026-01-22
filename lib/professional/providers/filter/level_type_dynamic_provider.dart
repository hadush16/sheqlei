// // // Provider for Employment Types (Full-time, Contract, etc.)
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:sheqlee/models/job_level_model.dart';
// // import 'package:sheqlee/models/job_type_model.dart';

// // final jobTypesProvider = FutureProvider<List<JobType>>((ref) async {
// //   // Replace this with your actual API call later: JobApi.fetchTypes()
// //   final mockTypes = [
// //     {"_id": "ft_01", "name": "Full-time"},
// //     {"_id": "pt_02", "name": "Part-time"},
// //     {"_id": "ct_03", "name": "Contract"},
// //     {"_id": "pt_04", "name": "Per diem"},
// //     {"_id": "pt_05", "name": "Temporary"},
// //   ];
// //   return mockTypes.map((e) => JobType.fromJson(e)).toList();
// // });

// // // Provider for Experience Levels (Junior, Expert, etc.)
// // final jobLevelsProvider = FutureProvider<List<JobLevel>>((ref) async {
// //   // Replace this with your actual API call later: JobApi.fetchLevels()
// //   final mockLevels = [
// //     {"_id": "lvl_01", "name": "Beginner"},
// //     {"_id": "lvl_02", "name": "Intermediate"},
// //     {"_id": "lvl_03", "name": "Expert"},
// //     {"_id": "lvl_04", "name": "Senior"},
// //   ];
// //   return mockLevels.map((e) => JobLevel.fromJson(e)).toList();
// // });

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Match the Mongoose enum: ['full_time', 'part_time', 'contract', 'per-diem', 'temporary']
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/h/job_level_model.dart';
// import 'package:sheqlee/h/job_type_model.dart';

// // Provider for Employment Types
// final jobTypesProvider = Provider<List<JobType>>((ref) {
//   return [
//     JobType(id: 'full_time', name: 'Full Time'),
//     JobType(id: 'part_time', name: 'Part Time'),
//     JobType(id: 'contract', name: 'Contract'),
//     JobType(id: 'internship', name: 'Internship'),
//     JobType(id: 'freelance', name: 'Freelance'),
//   ];
// });

// // Provider for Experience Levels
// final jobLevelsProvider = Provider<List<JobLevel>>((ref) {
//   return [
//     JobLevel(id: 'junior', name: 'Junior'),
//     JobLevel(id: 'mid', name: 'Mid Level'),
//     JobLevel(id: 'senior', name: 'Senior'),
//     JobLevel(id: 'expert', name: 'Expert'),
//   ];
// });
// 1. Dynamic Provider for Employment Types
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/job_level_model.dart';
import 'package:sheqlee/professional/models/job_type_model.dart';
import 'package:sheqlee/professional/providers/jobs/job_notifier.dart';
import 'package:sheqlee/professional/models/job.dart';

// Provider for Types based on what is currently in the DB
// Helper to get the internal number
// 1. Define this OUTSIDE of any class so it is a "top-level" method
int _getInternalLevelValue(String levelId) {
  final l = levelId.toLowerCase();
  if (l.contains('begin') || l.contains('junior')) return 1;
  if (l.contains('inter')) return 2;
  if (l.contains('seni')) return 3;
  if (l.contains('expert')) return 4;
  return 0; // Default for anything else
}

// 2. Your dynamic provider
final dynamicJobLevelsProvider = Provider<List<JobLevel>>((ref) {
  final jobsAsync = ref.watch(jobsProvider);

  return jobsAsync.maybeWhen(
    data: (jobs) {
      // Use .toSet() on the IDs/Strings to kill duplicates instantly
      final uniqueLevelStrings = jobs
          .map((j) => j.experienceLevel.trim())
          .whereType<String>()
          .toSet()
          .toList();

      final List<JobLevel> levelObjects = uniqueLevelStrings.map((name) {
        return JobLevel(
          id: name,
          name: name.toDisplayTitle(),
          levelValue: _getInternalLevelValue(name), // This call will now work
        );
      }).toList();

      // 3. Sort them so 1 is at the top, 4 is at the bottom
      levelObjects.sort((a, b) => a.levelValue.compareTo(b.levelValue));

      return levelObjects;
    },
    orElse: () => [],
  );
});

final dynamicJobTypesProvider = Provider<List<JobType>>((ref) {
  final jobsAsync = ref.watch(jobsProvider);

  return jobsAsync.maybeWhen(
    data: (jobs) {
      // 1. Extract and Normalize (Clean the data)
      final uniqueTypeStrings = jobs
          .map((j) => j.employmentType.trim()) // Remove hidden spaces
          .where((type) => type.isNotEmpty) // Ensure no empty strings
          .map((type) => type.toLowerCase()) // Make lowercase for comparison
          .toSet() // Remove duplicates
          .toList();

      // 2. Map back to JobType objects
      return uniqueTypeStrings
          .map(
            (type) => JobType(
              id: type,
              name: type.toDisplayTitle(), // 'full_time' becomes 'Full Time'
            ),
          )
          .toList();
    },
    orElse: () => [],
  );
});
