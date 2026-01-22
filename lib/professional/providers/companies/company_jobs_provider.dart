// Fetch jobs specifically for one company
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/core/network/network_provider.dart';

final companyJobsProvider = FutureProvider.autoDispose
    .family<List<Job>, String>((ref, companyId) async {
      final client = ref.read(httpClientProvider);

      try {
        final response = await client.get('/jobs/company/$companyId');

        if (response['success'] == false) {
          return []; // Return empty list to prevent UI freeze
        }

        // --- THE FIX STARTS HERE ---
        // 1. Get the main data object (the Map)
        final dynamic fullData = response['data'];

        // 2. Identify where the List actually lives
        List<dynamic> rawList = [];

        if (fullData is Map) {
          // If backend returns { "data": { "jobs": [...] } }
          if (fullData['data'] != null && fullData['data']['jobs'] is List) {
            rawList = fullData['data']['jobs'];
          }
          // If backend returns { "data": [...] }
          else if (fullData['data'] is List) {
            rawList = fullData['data'];
          }
          // If backend returns { "jobs": [...] }
          else if (fullData['jobs'] is List) {
            rawList = fullData['jobs'];
          }
        } else if (fullData is List) {
          rawList = fullData;
        }
        // --- THE FIX ENDS HERE ---

        return rawList.map((json) => Job.fromJson(json)).toList();
      } catch (e) {
        debugPrint("Final error check: $e");
        return []; // Return empty instead of crashing the design
      }
    });
