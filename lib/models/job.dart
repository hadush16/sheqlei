import 'package:sheqlee/models/job_detail.dart';

// class Job {
//   final String time;
//   final String title;
//   final String company;
//   final String shortDescription; // Changed from List to String
//   final List<String> tags;
//   final JobDetail? details; // Link to the full data

//   Job({
//     required this.time,
//     required this.title,
//     required this.company,
//     required this.shortDescription,
//     required this.tags,
//     this.details,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       time: json["time"] ?? "",
//       title: json["title"] ?? "",
//       company: json["company"] ?? "",
//       // Fix: JSON description is a String, so we read it as a String
//       shortDescription: json["shortDescription"] ?? "",
//       tags: List<String>.from(json["tags"] ?? []),
//       details: JobDetail.fromJson(json), // Parse the extra fields here
//     );
//   }

//   get id => null;
// }

class Job {
  final String id;
  final String time;
  final String title;
  final String company;
  final String shortDescription;
  final String typeId; // Linked to JobType
  final String levelId; // Linked to JobLevel
  final String salary; // Unique string per job
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
      details: JobDetail.fromJson(json),
    );
  }
}
