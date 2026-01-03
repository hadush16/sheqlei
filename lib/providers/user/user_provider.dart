// lib/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/user_model.dart';
// import 'package:http/http.dart' as http; // Uncomment when you have your API URL

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier() : super(const AsyncValue.data(null));

  // Method to set user manually (e.g., during Login)
  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }

  // API Call: Fetch Profile from Server
  Future<void> fetchUserProfile(String userId) async {
    state = const AsyncValue.loading();
    try {
      // Simulate API Call
      await Future.delayed(const Duration(seconds: 1));

      // Replace with actual API call:
      // final response = await http.get(Uri.parse('https://api.sheqlee.com/user/$userId'));
      // final user = UserModel.fromJson(jsonDecode(response.body));

      // Mock Data for now:
      final user = UserModel(
        id: userId,
        username: "User_Name",
        email: "user@example.com",
      );

      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Clear user on Logout
  void logout() {
    state = const AsyncValue.data(null);
  }
}

// The Global Provider
final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
      return UserNotifier();
    });
