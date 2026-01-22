import 'package:sheqlee/professional/models/job.dart';

class CategoryJobResponse {
  final List<Job> jobs;
  final int total;

  CategoryJobResponse({required this.jobs, required this.total});
}
