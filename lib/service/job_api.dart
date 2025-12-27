import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sheqlee/models/job.dart';

class JobApi {
  static Future<List<Job>> fetchJobs(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    final String response = await rootBundle.loadString("assets/jobs.json");

    final List data = jsonDecode(response);

    // Simulate pagination
    const pageSize = 5;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    if (start >= data.length) return [];

    return data
        .sublist(start, end.clamp(0, data.length))
        .map((e) => Job.fromJson(e))
        .toList();
  }
}
