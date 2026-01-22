class JobType {
  final String id;
  final String name; // e.g., "Full-time", "Remote", "Contract"

  JobType({required this.id, required this.name});

  factory JobType.fromJson(Map<String, dynamic> json) =>
      JobType(id: json["_id"] ?? "", name: json["name"] ?? "");
}
