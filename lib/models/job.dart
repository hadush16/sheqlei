class Job {
  final String time;
  final String title;
  final String company;
  final String shortDescription; // Changed from List to String
  final List<String> tags;
  final JobDetail? details; // Link to the full data

  Job({
    required this.time,
    required this.title,
    required this.company,
    required this.shortDescription,
    required this.tags,
    this.details,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      time: json["time"] ?? "",
      title: json["title"] ?? "",
      company: json["company"] ?? "",
      // Fix: JSON description is a String, so we read it as a String
      shortDescription: json["shortDescription"] ?? "",
      tags: List<String>.from(json["tags"] ?? []),
      details: JobDetail.fromJson(json), // Parse the extra fields here
    );
  }

  get id => null;
}

class JobDetail {
  final String location;
  final String qualifications;
  final String experience; // Changed to String for paragraph
  final List<String> skills; // Kept as List for bullet points
  final String description; // Changed to String for paragraph

  JobDetail({
    required this.location,
    required this.qualifications,
    required this.experience,
    required this.skills,
    required this.description,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    // Helper to join lists into a single paragraph with newlines if needed
    String parseAsParagraph(dynamic input) {
      if (input == null) return "Not specified";
      if (input is List) return input.join("\n\n");
      return input.toString();
    }

    return JobDetail(
      location: json["location"] ?? "Not specified",
      qualifications: json["Qualifications"] is List
          ? (json["Qualifications"] as List).first.toString()
          : (json["Qualifications"] ?? "Not specified"),
      experience: parseAsParagraph(json["Experience"]),
      skills: List<String>.from(json["Skills & Knowledge"] ?? []),
      description: parseAsParagraph(json["description"]),
    );
  }
}
