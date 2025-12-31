import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/tag_model.dart'; // Ensure this path matches your Tag class file

final tagsProvider = FutureProvider<List<Tag>>((ref) async {
  // Replace with your actual API call: JobApi.fetchTags()
  final mockTags = [
    {"_id": "t1", "name": "Java"},
    {"_id": "t2", "name": "User Interface"},
    {"_id": "t3", "name": "Python"},
    {"_id": "t4", "name": "C++"},
    {"_id": "t5", "name": "Flutter"},
  ];

  // Simulating network delay
  await Future.delayed(const Duration(milliseconds: 500));

  return mockTags.map((e) => Tag.fromJson(e)).toList();
});
