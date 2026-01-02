// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:sheqlee/models/job.dart';

// class JobApi {
//   static Future<List<Job>> fetchJobs(
//     int page, {
//     String? query,
//     String? tagId,
//     String? categoryId,
//   }) async {
//     await Future.delayed(
//       const Duration(seconds: 1),
//     ); // Reduced delay for better feel
//     final String response = await rootBundle.loadString("assets/jobs.json");

//     // 1. Decode into a List of Jobs first so we can filter easily
//     final List decodedData = jsonDecode(response);
//     List<Job> allJobs = decodedData.map((e) => Job.fromJson(e)).toList();

//     // 2. APPLY FILTERS (This is what was missing)
//     // 2. APPLY FILTERS inside your JobApi.fetchJobs method
//     if (tagId != null && tagId.isNotEmpty) {
//       final tagLow = tagId.toLowerCase();

//       allJobs = allJobs.where((job) {
//         // Check if the job's tag list contains the ID or Name selected
//         // Replace 'job.tags' with whatever your model calls subcategories
//         return job.tagIds.any((t) => t.toLowerCase() == tagLow) ||
//             job.title.toLowerCase().contains(tagLow);
//       }).toList();
//     }

//     if (query != null && query.isNotEmpty) {
//       final lowercaseQuery = query.toLowerCase();
//       allJobs = allJobs
//           .where(
//             (job) =>
//                 job.title.toLowerCase().contains(lowercaseQuery) ||
//                 job.shortDescription.toLowerCase().contains(lowercaseQuery),
//           )
//           .toList();
//     }

//     // 3. APPLY PAGINATION on the filtered list
//     const pageSize = 5;
//     final start = (page - 1) * pageSize;
//     final end = start + pageSize;

//     if (start >= allJobs.length) return [];

//     return allJobs.sublist(start, end.clamp(0, allJobs.length));
//   }
// }

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sheqlee/models/job.dart';
import 'package:sheqlee/data/mock_data.dart'; // Import to access mockCategories

class JobApi {
  static Future<List<Job>> fetchJobs(
    int page, {
    String? query,
    String? tagId,
    String? categoryId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // 1. Load the raw JSON data
    final String response = await rootBundle.loadString("assets/jobs.json");
    final List decodedData = jsonDecode(response);

    // 2. Map to Job objects
    List<Job> allJobs = decodedData.map((e) => Job.fromJson(e)).toList();

    // 3. APPLY FILTERS (The Core Fix)

    // Filter by Specific Tag (e.g., "tag_re" for React)
    if (tagId != null && tagId.isNotEmpty) {
      allJobs = allJobs.where((job) {
        // This looks inside the job's tags list for the specific ID from mockTags
        return job.tagIds != null && job.tagIds!.contains(tagId);
      }).toList();
    }

    // Filter by Category (Finds all tags belonging to that category)
    if (categoryId != null && categoryId.isNotEmpty) {
      try {
        // Find the category in your mock data to get its associated tagIds
        final category = mockCategories.firstWhere((c) => c.id == categoryId);

        allJobs = allJobs.where((job) {
          // Keep the job if it has ANY tag that belongs to this category
          return job.tagIds != null &&
              job.tagIds!.any((t) => category.tagIds.contains(t));
        }).toList();
      } catch (e) {
        // Category not found in mock data
      }
    }

    // Filter by Search Query (Text search in Title or Description)
    if (query != null && query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      allJobs = allJobs
          .where(
            (job) =>
                job.title.toLowerCase().contains(lowercaseQuery) ||
                job.shortDescription.toLowerCase().contains(lowercaseQuery),
          )
          .toList();
    }

    // 4. APPLY PAGINATION on the filtered result
    const pageSize = 5;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= allJobs.length) return [];

    return allJobs.sublist(start, end.clamp(0, allJobs.length));
  }
}
