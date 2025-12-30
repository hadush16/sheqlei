// class JobDetail {
//   final String location;
//   final String qualifications;
//   final String experience; // Changed to String for paragraph
//   final List<String> skills; // Kept as List for bullet points
//   final String description; // Changed to String for paragraph

//   JobDetail({
//     required this.location,
//     required this.qualifications,
//     required this.experience,
//     required this.skills,
//     required this.description,
//   });

//   factory JobDetail.fromJson(Map<String, dynamic> json) {
//     // Helper to join lists into a single paragraph with newlines if needed
//     String parseAsParagraph(dynamic input) {
//       if (input == null) return "Not specified";
//       if (input is List) return input.join("\n\n");
//       return input.toString();
//     }

//     return JobDetail(
//       location: json["location"] ?? "Not specified",
//       qualifications: json["Qualifications"] is List
//           ? (json["Qualifications"] as List).first.toString()
//           : (json["Qualifications"] ?? "Not specified"),
//       experience: parseAsParagraph(json["Experience"]),
//       skills: List<String>.from(json["Skills & Knowledge"] ?? []),
//       description: parseAsParagraph(json["description"]),
//     );
//   }
// }

class JobDetail {
  final String qualifications;
  final String experience;
  final List<String> skills;
  final String description;

  JobDetail({
    required this.qualifications,
    required this.experience,
    required this.skills,
    required this.description,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    String parseAsParagraph(dynamic input) {
      if (input == null) return "Not specified";
      if (input is List) return input.join("\n\n");
      return input.toString();
    }

    return JobDetail(
      qualifications: json["Qualifications"] is List
          ? (json["Qualifications"] as List).first.toString()
          : (json["Qualifications"] ?? "Not specified"),
      experience: parseAsParagraph(json["Experience"]),
      skills: List<String>.from(json["Skills & Knowledge"] ?? []),
      description: parseAsParagraph(json["description"]),
    );
  }
}
