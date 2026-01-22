// lib/models/category_model.dart
class Category {
  final String id;
  final String name;
  final String slug;
  final List<String>? tags;
  final String description;
  final int totalJobs;
  final int totalSubscribers;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.tags,
    required this.description,
    this.totalJobs = 0,
    this.totalSubscribers = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      // MongoDB returns _id, we map it to id
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'] ?? '',
      totalJobs: json['totalJobs'] ?? json['total_jobs'] ?? json['count'] ?? 0,
      totalSubscribers:
          json['totalSubscribers'] ?? json['total_subscribers'] ?? 0,
    );
  }
}
