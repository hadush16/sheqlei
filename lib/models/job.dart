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
}

class JobDetail {
  final String location;
  final List<String> qualifications;
  final List<String> experience;
  final List<String> skills;
  final List<String>
  discription; //  Added to hold additional description as a list

  JobDetail({
    required this.location,
    required this.qualifications,
    required this.experience,
    required this.skills,
    required this.discription,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    return JobDetail(
      location: json["location"] ?? "Not specified",
      qualifications: List<String>.from(json["Qualifications"] ?? []),
      experience: List<String>.from(json["Experience"] ?? []),
      skills: List<String>.from(json["Skills & Knowledge"] ?? []),
      discription: List<String>.from(json["discription"] ?? []),
    );
  }
}
