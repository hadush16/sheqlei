import 'package:sheqlee/professional/models/job.dart';
import 'package:sheqlee/professional/models/category_job_response.dart';
import 'package:sheqlee/core/network/network_provider.dart'; // Import your client

class CategoryDetailsApi {
  final AppNetworkClient _client; // Changed from Dio

  CategoryDetailsApi(this._client);

  Future<CategoryJobResponse> getJobsByCategory(String slug) async {
    try {
      // Use the new client with the query parameter
      // Your client handles the base URL + '/jobs' automatically
      final result = await _client.get('/jobs?category=$slug');

      if (result['success'] == true) {
        final data = result['data'];

        // Accessing jobs from the backend structure: data -> data -> jobs
        final List jobsList = data['data']['jobs'] ?? [];

        // Accessing total results
        final int total = data['results'] ?? data['total'] ?? 0;

        return CategoryJobResponse(
          jobs: jobsList.map((j) => Job.fromJson(j)).toList(),
          total: total,
        );
      }

      // Return empty response on network failure instead of pausing
      return CategoryJobResponse(jobs: [], total: 0);
    } catch (e) {
      print("Error fetching category jobs: $e");
      return CategoryJobResponse(jobs: [], total: 0);
    }
  }
}
