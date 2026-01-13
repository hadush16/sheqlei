// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/models/job.dart';
// import 'package:sheqlee/models/job_level_model.dart';
// import 'package:sheqlee/models/job_type_model.dart';
// import 'package:sheqlee/providers/jobs/level_type_notifier.dart'; // Ensure this matches your provider path

// class JobMetadataSection extends ConsumerWidget {
//   final Job job;
//   final bool showRocketIcon;

//   const JobMetadataSection({
//     super.key,
//     required this.job,
//     this.showRocketIcon = false,
//   });

//   @override
// Widget build(BuildContext context, WidgetRef ref) {
//   // 1. Fetch the data from your existing Level and Type providers
//   final allTypes = ref.watch(jobTypesProvider).value ?? [];
//   final allLevels = ref.watch(jobLevelsProvider).value ?? [];
//   // 2. Resolve the names from IDs
//   final String typeName = allTypes
//       .firstWhere(
//         (t) => t.id == job.typeId,
//         orElse: () => JobType(id: '', name: ''),
//       )
//       .name;
//   final String levelName = allLevels
//       .firstWhere(
//         (l) => l.id == job.levelId,
//         orElse: () => JobLevel(id: '', name: ''),
//       )
//       .name;
//   // 3. Collect non-empty info (Type, Level, Salary)
//   String salaryText = "";
//   if (job.salary['min'] != null && job.salary['max'] != null) {
//     salaryText =
//         "${job.salary['min']} - ${job.salary['max']} ${job.salary['currency']}";
//   } else if (job.salary['currency'] != null) {
//     salaryText = "Salary: ${job.salary['currency']}";
//   }
//   final List<String> metadata = [
//     if (typeName.isNotEmpty) typeName,
//     if (levelName.isNotEmpty) levelName,
//     if (job.salary.isNotEmpty) salaryText,
//   ];
//   return Wrap(
//     spacing: 8,
//     runSpacing: 8,
//     crossAxisAlignment: WrapCrossAlignment.center,
//     children: [
//       if (showRocketIcon) _buildIconTag(),
//       ...metadata.map((text) => _buildTextChip(text)),
//     ],
//   );
// }
// Widget _buildIconTag() {
//   return Container(
//     padding: const EdgeInsets.all(6),
//     decoration: const BoxDecoration(
//       color: Colors.black,
//       shape: BoxShape.circle,
//     ),
//     child: const Icon(Icons.rocket_launch, color: Colors.white, size: 14),
//   );
// }
// Widget _buildTextChip(String label) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: Colors.grey.shade300),
//     ),
//     child: Text(
//       label,
//       style: const TextStyle(
//         fontSize: 12,
//         color: Colors.black87,
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';

class JobMetadataSection extends ConsumerWidget {
  final Job job;
  final bool showRocketIcon;

  const JobMetadataSection({
    super.key,
    required this.job,
    this.showRocketIcon = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Helper to format 'full_time' -> 'Full Time'
    String formatBackendString(String text) {
      if (text.isEmpty) return "";
      return text
          .replaceAll('_', ' ')
          .split(' ')
          .map((word) {
            if (word.isEmpty) return "";
            return word[0].toUpperCase() + word.substring(1);
          })
          .join(' ');
    }

    final String typeName = formatBackendString(job.employmentType);
    final String levelName = formatBackendString(job.experienceLevel);

    // 2. Format Salary Text from the Map
    String salaryText = "";
    final s = job.salary;
    if (s['min'] != null && s['max'] != null && s['min'] != 0) {
      salaryText = "${s['min']} - ${s['max']} ${s['currency']}";
    } else if (s['currency'] != null && s['currency'].toString().isNotEmpty) {
      salaryText = "${s['currency']}";
    } else {
      salaryText = "Negotiable";
    }

    // 3. Create the list of strings to display
    final List<String> metadata = [
      if (typeName.isNotEmpty) typeName,
      if (levelName.isNotEmpty) levelName else "No Level",
      if (salaryText.isNotEmpty) salaryText,
    ];
    // 4. Return the Wrap with actual children mapping
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (showRocketIcon) _buildIconlevel(),
        // This was missing/commented out in your code:
        ...metadata.map((text) => _buildTextChip(text)),
      ],
    );
  }

  Widget _buildIconlevel() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.rocket_launch, color: Colors.white, size: 14),
    );
  }

  Widget _buildTextChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
