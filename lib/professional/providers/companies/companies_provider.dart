import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/network_provider.dart';
import '../../models/company_model.dart';

final companiesProvider = FutureProvider<List<CompanyModel>>((ref) async {
  final client = ref.read(httpClientProvider);
  try {
    // 1. Fetch Companies
    final result = await client.get('/companies');
    final List<dynamic> rawCompanies =
        result['data']?['data']?['companies'] ?? [];
    List<CompanyModel> companies = rawCompanies
        .map((json) => CompanyModel.fromJson(json))
        .toList();

    // 2. Fetch Job Counts for each company using your specific route
    // This happens in parallel for better performance
    final updatedCompanies = await Future.wait(
      companies.map((company) async {
        try {
          final jobResponse = await client.get('/jobs/company/${company.id}');
          // Assuming your backend returns { results: count, ... } or { data: [...] }
          final int jobCount = jobResponse['data']['results'] ?? 0;
          return company.copyWith(totalJobs: jobCount);
        } catch (e) {
          return company; // If job fetch fails, return company with 0 jobs
        }
      }),
    );

    return updatedCompanies;
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? "Network Error";
  }
});
