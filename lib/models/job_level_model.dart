class JobLevel {
  final String id;
  final String name; // e.g., "Junior", "Intermediate", "Expert"

  JobLevel({required this.id, required this.name});

  factory JobLevel.fromJson(Map<String, dynamic> json) =>
      JobLevel(id: json["_id"] ?? "", name: json["name"] ?? "");
}
