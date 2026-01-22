import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sheqlee/professional/models/category_model.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/models/tag_model.dart';

class JobApi {
  // Use 10.0.2.2 if you are using an Android Emulator
  static const String baseUrl = "http://192.168.0.109:3000/api/v1/jobs";
  static const String rootUrlcat =
      "http://192.168.0.109:3000/api/v1/categories";
  static const String rootUrltag = "http://192.168.0.109:3000/api/v1/tags";

  static Future<List<Job>> fetchJobs(
    int page, {
    String? query,
    String? categoryId,
    String? typeId, // ADD THIS
    String? levelId,
    String? tagId,
  }) async {
    try {
      // 1. Prepare Query Parameters for the backend
      final Map<String, dynamic> queryParams = {
        "page": page.toString(),
        "limit": "10",
      };
      // Only add if not null and NOT empty
      if (query != null && query.trim().isNotEmpty) {
        queryParams['keyword'] = query;
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['category'] = categoryId;
      }
      if (typeId != null && typeId.isNotEmpty) {
        queryParams['employmentType'] = typeId;
      }
      if (levelId != null && levelId.isNotEmpty) {
        queryParams['experienceLevel'] = levelId;
      }

      // EXPERIMENT: If your backend crashes with Error 500 on 'tags',
      // it might expect the key to be 'tag' (singular) or 'tags[]'.
      if (tagId != null && tagId.isNotEmpty) {
        // If 'tags' causes 500, try 'tags[]' or sending it as a List
        queryParams['tags'] = tagId;
        // queryParams['tags[]'] = tagId; // Try this if 'tags' fails
      }

      final Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      // 2. Make the request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List jobsList = body["data"]["jobs"];
        return jobsList.map((json) => Job.fromJson(json)).toList();
      } else {
        // Log the body to see the actual error from the server
        print("Server Response Error: ${response.body}");
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("JobApi Error: $e");
      // Return empty list on failure
      rethrow;
    }
  }

  // --- DEFENSIVE FIX FOR CATEGORIES ---
  // FIXED URL: Just use rootUrlcat directly
  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(rootUrlcat));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Based on your Controller: res.status(200).json({ data: { categories } })
        if (body['data'] != null && body['data']['categories'] != null) {
          final List rawList = body['data']['categories'];
          return rawList.map((json) => Category.fromJson(json)).toList();
        }
      }
      return [];
    } on TimeoutException catch (_) {
      print("Connection timed out - Internet too slow");
      return [];
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }

  // --- DEFENSIVE FIX FOR TAGS ---
  // FIXED URL: Just use rootUrltag directly
  static Future<List<Tag>> fetchTags() async {
    final response = await http.get(Uri.parse(rootUrltag));

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      dynamic rawList;
      if (body is Map && body.containsKey('data')) {
        rawList = body['data'];
        if (rawList is Map && rawList.containsKey('tags')) {
          rawList = rawList['tags'];
        }
      }
      if (rawList is List) {
        return rawList.map((json) => Tag.fromJson(json)).toList();
      }
    }
    return [];
  }

  static Future<List<Job>> searchJobs({String? tagId, String? query}) async {
    final Map<String, String> params = {};

    // Add tag ONLY if it is not null and not the string "null"
    if (tagId != null && tagId != "null" && tagId.isNotEmpty) {
      params['tag'] = tagId;
    }

    if (query != null && query.isNotEmpty) {
      params['q'] = query;
    }

    final uri = Uri.parse(
      "$baseUrl/jobs/search",
    ).replace(queryParameters: params);

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else if (response.statusCode == 500) {
      // Return empty list on Server Error instead of throwing to avoid the red screen
      return [];
    } else {
      return [];
    }
  }
}

// // import 'dart:convert';

// // import 'package:flutter/services.dart';
// // import 'package:sheqlee/models/job.dart';

// // class JobApi {
// //   static Future<List<Job>> fetchJobs(
// //     int page, {
// //     String? query,
// //     String? tagId,
// //     String? categoryId,
// //   }) async {
// //     await Future.delayed(
// //       const Duration(seconds: 1),
// //     ); // Reduced delay for better feel
// //     final String response = await rootBundle.loadString("assets/jobs.json");

// //     // 1. Decode into a List of Jobs first so we can filter easily
// //     final List decodedData = jsonDecode(response);
// //     List<Job> allJobs = decodedData.map((e) => Job.fromJson(e)).toList();

// //     // 2. APPLY FILTERS (This is what was missing)
// //     // 2. APPLY FILTERS inside your JobApi.fetchJobs method
// //     if (tagId != null && tagId.isNotEmpty) {
// //       final tagLow = tagId.toLowerCase();

// //       allJobs = allJobs.where((job) {
// //         // Check if the job's tag list contains the ID or Name selected
// //         // Replace 'job.tags' with whatever your model calls subcategories
// //         return job.tagIds.any((t) => t.toLowerCase() == tagLow) ||
// //             job.title.toLowerCase().contains(tagLow);
// //       }).toList();
// //     }

// //     if (query != null && query.isNotEmpty) {
// //       final lowercaseQuery = query.toLowerCase();
// //       allJobs = allJobs
// //           .where(
// //             (job) =>
// //                 job.title.toLowerCase().contains(lowercaseQuery) ||
// //                 job.shortDescription.toLowerCase().contains(lowercaseQuery),
// //           )
// //           .toList();
// //     }

// //     // 3. APPLY PAGINATION on the filtered list
// //     const pageSize = 5;
// //     final start = (page - 1) * pageSize;
// //     final end = start + pageSize;

// //     if (start >= allJobs.length) return [];

// //     return allJobs.sublist(start, end.clamp(0, allJobs.length));
// //   }
// // }

// // --- ADD THIS: Fetch Real Categories ---
//   // --- FIX FOR CATEGORIES ---
//   // static Future<List<Category>> fetchCategories() async {
//   //   final response = await http.get(Uri.parse('$rootUrl/categories'));
//   //   if (response.statusCode == 200) {
//   //     final Map<String, dynamic> body = jsonDecode(response.body);

//   //     // FIX: Access the list inside the object.
//   //     // If your backend returns { "data": [...] }, use body["data"]
//   //     final List list = body["data"] as List;

//   //     return list.map((json) => Category.fromJson(json)).toList();
//   //   }
//   //   throw Exception("Failed to load categories");
//   // }

//   // // --- FIX FOR TAGS ---
//   // static Future<List<Tag>> fetchTags() async {
//   //   final response = await http.get(Uri.parse('$rootUrl/tags'));
//   //   if (response.statusCode == 200) {
//   //     final Map<String, dynamic> body = jsonDecode(response.body);

//   //     // FIX: Same here. Ensure you are grabbing the List, not the whole Map
//   //     final List list = body["data"] as List;

//   //     return list.map((json) => Tag.fromJson(json)).toList();
//   //   }
//   //   throw Exception("Failed to load tags");
//   // }

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:sheqlee/models/category_model.dart';
// import 'package:sheqlee/models/job.dart';
// import 'package:sheqlee/models/tag_model.dart';

// class JobApi {
//   /// 🔹 Shared Dio instance (BASE NETWORK)
//   static Dio? _dio;

//   /// 🔹 Called ONCE from provider
//   static void init(Dio dio) {
//     _dio = dio;
//   }

//   /// 🔹 Safety check
//   static Dio get _client {
//     if (_dio == null) {
//       throw Exception('Dio not initialized. Call JobApi.init(dio)');
//     }
//     return _dio!;
//   }

//   // ========================= JOBS =========================

//   static Future<List<Job>> fetchJobs(
//     int page, {
//     String? query,
//     String? categoryId,
//     String? typeId,
//     String? levelId,
//     String? tagId,
//   }) async {
//     try {
//       final Map<String, dynamic> queryParams = {"page": page, "limit": 10};

//       if (query != null && query.isNotEmpty) queryParams['keyword'] = query;
//       if (categoryId != null && categoryId.isNotEmpty) {
//         queryParams['category'] = categoryId;
//       }
//       if (typeId != null && typeId.isNotEmpty) {
//         queryParams['employmentType'] = typeId;
//       }
//       if (levelId != null && levelId.isNotEmpty) {
//         queryParams['experienceLevel'] = levelId;
//       }
//       if (tagId != null && tagId.isNotEmpty) {
//         queryParams['tags'] = tagId;
//       }

//       final response = await _client.get('/jobs', queryParameters: queryParams);

//       final List list = response.data['data']['jobs'];
//       return list.map((e) => Job.fromJson(e)).toList();
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     } on SocketException {
//       throw Exception('No internet connection');
//     }
//   }

//   // ===================== CATEGORIES =====================

//   static Future<List<Category>> fetchCategories() async {
//     try {
//       final response = await _client.get('/categories');
//       final List list = response.data['data']['categories'];
//       return list.map((e) => Category.fromJson(e)).toList();
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   // ======================== TAGS ========================

//   static Future<List<Tag>> fetchTags() async {
//     try {
//       final response = await _client.get('/tags');
//       final List list = response.data['data']['tags'];
//       return list.map((e) => Tag.fromJson(e)).toList();
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   static Future<List<Job>> searchJobs({String? tagId, String? query}) async {
//     try {
//       final Map<String, dynamic> queryParams = {};

//       // Add query only if not null or empty
//       if (query != null && query.isNotEmpty) {
//         queryParams['keyword'] = query;
//       }

//       // Add tag only if not null or empty
//       if (tagId != null && tagId.isNotEmpty && tagId != "null") {
//         queryParams['tags'] = tagId;
//       }

//       // Call the API using Dio
//       final response = await _client.get(
//         '/jobs/search',
//         queryParameters: queryParams,
//       );

//       // Extract jobs
//       final List list = response.data['data']['jobs'];
//       return list.map((e) => Job.fromJson(e)).toList();
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     } on SocketException {
//       throw Exception('No internet connection');
//     } catch (e) {
//       throw Exception('Unexpected error: $e');
//     }
//   }

//   // ==================== ERROR HANDLER ====================

//   static void _handleDioError(DioException e) {
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       throw Exception('Connection timeout');
//     }

//     if (e.type == DioExceptionType.connectionError) {
//       throw Exception('Network error');
//     }

//     if (e.response != null) {
//       throw Exception(e.response?.data['message'] ?? 'Server error');
//     }

//     throw Exception('Unexpected error');
//   }
// }
