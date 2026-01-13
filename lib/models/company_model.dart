class CompanyModel {
  final String id;
  final String name;
  final String domain;
  final String description;
  final bool isVerified;
  final String location; // Added
  final String size; // Added
  final int totalJobs; // Will be updated via the second API call
  final int totalSubscribers;

  CompanyModel({
    required this.id,
    required this.name,
    required this.domain,
    this.description = '',
    this.isVerified = false,
    this.location = 'Unknown',
    this.size = '1-10',
    this.totalJobs = 0,
    this.totalSubscribers = 0,
  });

  // This copyWith is essential for updating the job count later
  CompanyModel copyWith({int? totalJobs}) {
    return CompanyModel(
      id: id,
      name: name,
      domain: domain,
      description: description,
      isVerified: isVerified,
      location: location,
      size: size,
      totalJobs: totalJobs ?? this.totalJobs,
      totalSubscribers: totalSubscribers,
    );
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      domain: json['domain'] ?? '',
      description: json['description'] ?? '',
      isVerified: json['isVerified'] ?? false,
      location: json['location'] ?? 'Addis Ababa', // Default if missing
      size: json['size'] ?? '10-50', // Default if missing
      totalSubscribers: json['subscribersCount'] ?? 0,
    );
  }
}
