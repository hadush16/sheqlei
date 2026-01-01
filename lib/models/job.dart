import 'package:sheqlee/models/job_detail.dart';

class Job {
  final String id;
  final String time;
  final String title;
  final String company;
  final String shortDescription;
  final String typeId; // Linked to JobType
  final String levelId; // Linked to JobLevel
  final String salary; // Unique string per job
  final String categoryId; // NEW: Link to Category ID
  final List<String> tagIds;
  final JobDetail? details;

  Job({
    required this.id,
    required this.time,
    required this.title,
    required this.company,
    required this.shortDescription,
    required this.typeId,
    required this.levelId,
    required this.salary,
    required this.categoryId,
    required this.tagIds,
    this.details,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["_id"] ?? "",
      time: json["time"] ?? "",
      title: json["title"] ?? "",
      company: json["company"] ?? "",
      shortDescription: json["shortDescription"] ?? "",
      typeId: json["typeId"] ?? "",
      levelId: json["levelId"] ?? "",
      salary: json["salary"] ?? "",
      categoryId: json["categoryId"] ?? "", // Map category
      tagIds: List<String>.from(json["tagIds"] ?? []), // Map tags
      details: JobDetail.fromJson(json),
    );
  }
}
