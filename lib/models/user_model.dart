// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePic;
  final String accountType; // Matches 'accountType' (professional/employer)

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accountType,
    this.profilePic,
  });

  // Factory to convert API JSON to this object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json['data'] ?? json;
    return UserModel(
      id: json['id'] ?? '',
      name: userData['name'] ?? 'Guest',
      accountType: userData['accountType'] ?? 'professional',
      email: json['email'] ?? '',
      profilePic: json['profile_pic'],
    );
  }
}
