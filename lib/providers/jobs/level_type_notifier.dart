// Provider for Employment Types (Full-time, Contract, etc.)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/models/job_type_model.dart';

final jobTypesProvider = FutureProvider<List<JobType>>((ref) async {
  // Replace this with your actual API call later: JobApi.fetchTypes()
  final mockTypes = [
    {"_id": "ft_01", "name": "Full-time"},
    {"_id": "pt_02", "name": "Part-time"},
    {"_id": "ct_03", "name": "Contract"},
    {"_id": "pt_04", "name": "Per diem"},
    {"_id": "pt_05", "name": "Temporary"},
  ];
  return mockTypes.map((e) => JobType.fromJson(e)).toList();
});

// Provider for Experience Levels (Junior, Expert, etc.)
final jobLevelsProvider = FutureProvider<List<JobLevel>>((ref) async {
  // Replace this with your actual API call later: JobApi.fetchLevels()
  final mockLevels = [
    {"_id": "lvl_01", "name": "Beginner"},
    {"_id": "lvl_02", "name": "Intermediate"},
    {"_id": "lvl_03", "name": "Expert"},
    {"_id": "lvl_04", "name": "Senior"},
  ];
  return mockLevels.map((e) => JobLevel.fromJson(e)).toList();
});
