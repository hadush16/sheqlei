// import 'package:sheqlee/models/job_detail.dart';

// class Job {
//   final String id;
//   final String time;
//   final String title;
//   final String company;
//   final String shortDescription;
//   final String typeId; // Linked to JobType
//   final String levelId; // Linked to JobLevel
//   final String salary; // Unique string per job
//   final String categoryId; // NEW: Link to Category ID
//   final List<String> tagIds;
//   final JobDetail? details;

//   Job({
//     required this.id,
//     required this.time,
//     required this.title,
//     required this.company,
//     required this.shortDescription,
//     required this.typeId,
//     required this.levelId,
//     required this.salary,
//     required this.categoryId,
//     required this.tagIds,
//     this.details,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json["_id"] ?? "",
//       time: json["time"] ?? "",
//       title: json["title"] ?? "",
//       company: json["company"] ?? "",
//       shortDescription: json["shortDescription"] ?? "",
//       typeId: json["typeId"] ?? "",
//       levelId: json["levelId"] ?? "",
//       salary: json["salary"] ?? "",
//       categoryId: json["categoryId"] ?? "", // Map category
//       tagIds: List<String>.from(json["tagIds"] ?? []), // Map tags
//       details: JobDetail.fromJson(json),
//     );
//   }
// }

import 'package:sheqlee/professional/models/tag_model.dart';

extension JobStringExtension on String {
  String toDisplayTitle() {
    if (isEmpty) return this;
    return replaceAll('_', ' ')
        .split(' ')
        .map(
          (str) =>
              str.isNotEmpty ? str[0].toUpperCase() + str.substring(1) : str,
        )
        .join(' ');
  }
}

// class Job {
//   final String id;
//   final String title;
//   final String companyName;
//   final String shortDescription;
//   final String description;
//   final String location;
//   final String employmentType; // Mapped from employmentType
//   final String experienceLevel; // Mapped from experienceLevel
//   final String categoryId;
//   final List<Tag> tagIds;
//   List<String>? tags;

//   final Map<String, dynamic> salary;
//   final DateTime createdAt;

//   Job({
//     required this.id,
//     required this.title,
//     required this.companyName,
//     required this.shortDescription,
//     required this.description,
//     required this.location,
//     required this.employmentType,
//     required this.experienceLevel,
//     required this.categoryId,
//     required this.tagIds,
//     this.tags,
//     required this.salary,
//     required this.createdAt,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json["_id"] ?? "",
//       title: json["title"] ?? "",
//       // Backend provides company as an object with name
//       // 1. COMPANY: Map the nested name
//       companyName: (json["company"] is Map)
//           ? json["company"]["name"]
//           : "Unknown Company",

//       shortDescription: json["description"] ?? "",
//       description: json["description"] ?? "",
//       location: json["location"] ?? "Remote",
//       // Map backend 'employmentType' string to your local 'typeId'
//       employmentType:
//           json['employmentType'] ??
//           'full_time', // Map backend 'experienceLevel' string to your local 'levelId'
//       experienceLevel: json["experienceLevel"] ?? "Expert",
//       categoryId: json["category"] ?? "",
//       // Tags might come as a list of Strings or Objects; this ensures they are Strings
//       //tagIds: (json["tags"] as List?)?.map((t) => t.toString()).toList() ?? [],
//       // tagIds:
//       //     (json['tags'] as List?)?.map((t) => Tag.fromJson(t)).toList() ?? [],
//       tagIds:
//           (json['tags'] as List?)?.map((t) => Tag.fromJson(t)).toList() ?? [],
//       salary:
//           json["salary"] ??
//           {"min": 0, "max": 0, "currency": "ETB", "unit": "month"},

//       // Correctly parsing the String from JSON into a DateTime object
//       createdAt: DateTime.parse(
//         json["createdAt"] ?? DateTime.now().toIso8601String(),
//       ),
//     );
//   }
// }
class Job {
  final String id;
  final String title;
  final String companyName;
  final String shortDescription;
  final String description;
  final String location;
  final String employmentType;
  final String experienceLevel;
  final String categoryId;
  final List<Tag> tagIds;
  final List<String>? tags; // The list of slugs/strings
  final Map<String, dynamic> salary;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.shortDescription,
    required this.description,
    required this.location,
    required this.employmentType,
    required this.experienceLevel,
    required this.categoryId,
    required this.tagIds,
    this.tags,
    required this.salary,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // 1. Handle Tags (check if they are Objects or Strings)
    var rawTags = json['tags'] as List? ?? [];

    List<Tag> parsedTagObjects = [];
    List<String> parsedTagSlugs = [];

    for (var t in rawTags) {
      if (t is Map<String, dynamic>) {
        parsedTagObjects.add(Tag.fromJson(t));
        // If it's an object, grab the name or slug for the string list
        parsedTagSlugs.add(t['name']?.toString().toLowerCase() ?? "");
      } else {
        parsedTagSlugs.add(t.toString().toLowerCase());
      }
    }

    // 2. Handle Descriptions (ensure they are different)
    String fullDesc = json["description"] ?? "";
    // If backend doesn't provide 'summary', we fallback to a substring
    String shortDesc =
        json["summary"] ??
        (fullDesc.length > 100 ? "${fullDesc.substring(0, 100)}..." : fullDesc);

    // 3. Final Return (Ensures no 'null' is returned)
    return Job(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      companyName: (json["company"] is Map)
          ? json["company"]["name"]
          : "Unknown Company",
      shortDescription: shortDesc,
      description: fullDesc,
      location: json["location"] ?? "Remote",
      employmentType: json['employmentType'] ?? 'full_time',
      experienceLevel: json["experienceLevel"] ?? "Junior",
      categoryId: json["category"] ?? "",
      tagIds: parsedTagObjects,
      tags: parsedTagSlugs, // Now this contains lowercase strings for searching
      salary:
          json["salary"] ??
          {"min": 0, "max": 0, "currency": "ETB", "unit": "month"},
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
