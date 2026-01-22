import 'package:sheqlee/professional/models/category_model.dart';

class Tag {
  final String id;
  final String name;
  final String description;
  final int totalJobs;
  final int totalSubscribers;
  final List<Category>? categories; // List of categories linked to this tag

  Tag({
    required this.id,
    required this.name,
    required this.description,
    this.totalJobs = 0,
    this.totalSubscribers = 0,
    this.categories,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // Map these to the exact keys your API uses (e.g., jobCount or total_jobs)
      totalJobs: json['totalJobs'] ?? json['jobCount'] ?? 0,
      totalSubscribers:
          json['totalSubscribers'] ?? json['subscriberCount'] ?? 0,
    );
  }
}
