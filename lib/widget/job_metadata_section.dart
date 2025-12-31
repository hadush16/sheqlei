import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/models/job_type_model.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart'; // Ensure this matches your provider path

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
    // 1. Fetch the data from your existing Level and Type providers
    final allTypes = ref.watch(jobTypesProvider).value ?? [];
    final allLevels = ref.watch(jobLevelsProvider).value ?? [];

    // 2. Resolve the names from IDs
    final String typeName = allTypes
        .firstWhere(
          (t) => t.id == job.typeId,
          orElse: () => JobType(id: '', name: ''),
        )
        .name;

    final String levelName = allLevels
        .firstWhere(
          (l) => l.id == job.levelId,
          orElse: () => JobLevel(id: '', name: ''),
        )
        .name;

    // 3. Collect non-empty info (Type, Level, Salary)
    final List<String> metadata = [
      if (typeName.isNotEmpty) typeName,
      if (levelName.isNotEmpty) levelName,
      if (job.salary.isNotEmpty) job.salary,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (showRocketIcon) _buildIconTag(),
        ...metadata.map((text) => _buildTextChip(text)).toList(),
      ],
    );
  }

  Widget _buildIconTag() {
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
