// Fetch jobs specifically for one company
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/dio_client.dart';
import 'package:sheqlee/models/job.dart';

final companyJobsProvider = FutureProvider.autoDispose
    .family<List<Job>, String>((ref, companyId) async {
      final dio = ref.read(dioProvider);
      try {
        final response = await dio.get('/jobs/company/$companyId');
        // Adjust mapping based on your backend response structure
        final List data =
            response.data['data']['jobs'] ?? response.data['data'] ?? [];
        return data.map((json) => Job.fromJson(json)).toList();
      } on DioException catch (e) {
        throw e.response?.data['message'] ?? "Could not load jobs";
      }
    });
