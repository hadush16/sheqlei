import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart'; // Ensure this is your ONLY job import
import 'package:sheqlee/providers/jobs/job_notifier.dart';
import 'package:sheqlee/providers/profile/edit_profile_provider.dart';

// 1. GLOBAL HELPER (Defined outside the class so Provider can see it)
int getInternalLevelValue(String? levelId) {
  if (levelId == null) return 0;
  final l = levelId.toLowerCase();
  if (l.contains('begin') || l.contains('junior')) return 1;
  if (l.contains('inter')) return 2;
  if (l.contains('seni')) return 3;
  if (l.contains('expert')) return 4;
  return 0;
}

final filteredJobsProvider = Provider<AsyncValue<List<Job>>>((ref) {
  final jobsAsync = ref.watch(jobsProvider);
  final profileState = ref.watch(profileProvider);

  return jobsAsync.whenData((jobs) {
    final userSkills = profileState.skills;

    if (userSkills.isEmpty) return [];

    return jobs.where((job) {
      // 1. Safe access to job.tags using ?? []
      final jobTags = job.tags ?? [];

      // 2. SEARCH LOGIC:
      // Check if any of the user's skill names match any ID/slug in the job's tags
      bool hasMatch = jobTags.any(
        (jobTagId) => userSkills.any(
          (skill) => skill.tagName.toLowerCase() == jobTagId.toLowerCase(),
        ),
      );

      if (!hasMatch) return false;

      // 3. LEVEL MATCHING:
      // Find the specific user skill that matched to check the level
      final matchingUserSkill = userSkills.firstWhere(
        (skill) => jobTags.any(
          (jobTagId) => jobTagId.toLowerCase() == skill.tagName.toLowerCase(),
        ),
        orElse: () => userSkills.first,
      );

      int userLevel = getInternalLevelValue(matchingUserSkill.levelName);
      int jobLevel = getInternalLevelValue(job.experienceLevel);

      // Return true if user's level is equal to or higher than the job requirement
      return userLevel >= jobLevel;
    }).toList();
  });
});
