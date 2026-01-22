// lib/providers/tags/tags_provider.dart

// 1. Stats Provider with Design Fallbacks
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/network_provider.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tag_provider_for_jobcount.dart';

// lib/providers/tags/tags_provider.dart

// 1. Stats Provider with Design Fallbacks
final tagStatsProvider = FutureProvider.family<Map<String, String>, String>((
  ref,
  tagId,
) async {
  try {
    final data = await ref.watch(tagApiProvider).fetchTagStats(tagId); //

    final int jobCount = data['totalJobs'] ?? 0;
    final int subCount = data['subscriberCount'] ?? 0;

    // Logic: If DB returns 0, use your mock design numbers
    return {
      'jobs': jobCount > 0 ? "$jobCount Jobs" : "89 Jobs",
      'subs': subCount > 0 ? "$subCount Subs" : "1780 Subs",
    };
  } catch (e) {
    return {'jobs': "89 Jobs", 'subs': "1780 Subs"};
  }
});

// lib/providers/tags/tags_provider.dart

// lib/providers/tags/tags_provider.dart

final jobsByTagProvider = FutureProvider.family<List<Job>, String>((
  ref,
  tagId,
) async {
  // 1. Use the new client instead of the old static JobApi.fetchJobs
  final client = ref.read(httpClientProvider);

  try {
    // 2. Call the endpoint directly
    final result = await client.get('/jobs?tag=$tagId');

    if (result['success'] == true) {
      final responseData = result['data'];
      final List<dynamic> rawJobs = responseData['data']?['jobs'] ?? [];
      return rawJobs.map((json) => Job.fromJson(json)).toList();
    }

    // If server returns success: false (like a 500 error), trigger the catch block
    throw Exception("Server Error");
  } catch (e) {
    debugPrint("Backend Error: $e. Returning mock jobs to maintain UI design.");

    // 3. YOUR MOCK DESIGN (Stays exactly the same)
    final mockTag = Tag(
      id: tagId,
      name: "Java",
      description: "Mock Description",
      totalJobs: 89,
      totalSubscribers: 1780,
    );

    return [
      Job(
        id: "mock-1",
        title: "Senior Java Developer",
        companyName: "Google Ethiopia",
        location: "Addis Ababa",
        salary: {},
        employmentType: "Full-time",
        shortDescription: "",
        description:
            "The ideal candidate will be responsible for helping us develop a wide variety of projects leveraging PostgreSQL, Django and Python.",
        experienceLevel: "",
        categoryId: '',
        createdAt: DateTime.now(),
        tagIds: [mockTag],
      ),
      // ... keep your other mock jobs exactly as they are
    ];
  }
});

// lib/providers/tags/tags_provider.dart

final tagCategoriesProvider = Provider.family<List<dynamic>, Tag>((ref, tag) {
  // 1. Check if real data exists from the database
  if (tag.categories != null && tag.categories!.isNotEmpty) {
    return tag.categories!;
  }

  // 2. Fallback Mock Data to match your design image
  return [
    {'name': 'Backend Development'},
    {'name': 'Native Mobile Development'},
    {'name': 'Systems Development'},
  ];
});

// lib/providers/tags/tags_provider.dart

final tagDetailProvider = FutureProvider.family<Tag, Tag>((
  ref,
  initialTag,
) async {
  try {
    // Attempt to fetch fresh stats/details from your API
    final data = await ref.watch(tagApiProvider).fetchTagStats(initialTag.id);

    // Return the tag with updated data from database
    return Tag(
      id: initialTag.id,
      name: initialTag.name,
      description:
          (data['description'] != null && data['description'].isNotEmpty)
          ? data['description']
          : "Java is a versatile, object-oriented language used for building cross-platform applications, known for its performance and security.",
      totalJobs: data['totalJobs'] ?? 89,
      totalSubscribers: data['subscriberCount'] ?? 1780,
      categories: initialTag.categories,
    );
  } catch (e) {
    // DATABASE FAILED: Return the tag with FULL Mock data
    return Tag(
      id: initialTag.id,
      name: initialTag.name,
      description:
          "Java is a versatile, object-oriented language used for building cross-platform applications, known for its performance and security.",
      totalJobs: 89,
      totalSubscribers: 1780,
      categories: initialTag.categories,
    );
  }
});
