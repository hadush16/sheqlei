// lib/models/user_model.dart
class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profilePic;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic,
  });

  // Factory to convert API JSON to this object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Guest',
      email: json['email'] ?? '',
      profilePic: json['profile_pic'],
    );
  }
}
