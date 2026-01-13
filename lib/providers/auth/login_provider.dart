import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sheqlee/core/network/dio_client.dart';
import 'package:sheqlee/models/user_model.dart';
import 'package:sheqlee/providers/user/user_provider.dart';

class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final bool obscure;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.obscure = true,
    this.error,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? obscure,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      obscure: obscure ?? this.obscure,
      error: error,
    );
  }
}

/// =======================
/// NOTIFIER (LOGIC ONLY)
/// =======================
class LoginNotifier extends StateNotifier<LoginState> {
  final Ref ref;
  LoginNotifier(this.ref) : super(const LoginState());

  void setEmail(String value) {
    state = state.copyWith(email: value, error: null);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, error: null);
  }

  void toggleObscure() {
    state = state.copyWith(obscure: !state.obscure);
  }

  /// RETURN bool so UI knows what to do
  // Future<bool> login() async {
  //   final currentEmail = state.email.trim();
  //   final currentPassword = state.password;

  //   state = state.copyWith(isLoading: true, error: null);

  //   try {
  //     // Simulate network delay
  //     await Future.delayed(const Duration(seconds: 1));

  //     // --- LOCAL CHECK (PRESERVING BACKEND STRUCTURE) ---
  //     // You can add your test accounts here
  //     if (currentEmail == "h@gmail.com" && currentPassword == "1234") {
  //       // 1. Create the user model locally
  //       final loggedInUser = UserModel(
  //         id: "local_user_001",
  //         name: "h", // This is the name that shows in the Header
  //         email: currentEmail,
  //         accountType: 'professional',
  //       );

  //       // 2. CRITICAL: Update the global userProvider
  //       // This is what the SliverHeader is watching
  //       ref.read(userProvider.notifier).setUser(loggedInUser);

  //       return true;
  //     } else {
  //       state = state.copyWith(
  //         error: "The credentials you entered are incorrect.",
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     state = state.copyWith(error: "An unexpected error occurred.");
  //     return false;
  //   } finally {
  //     state = state.copyWith(isLoading: false);
  //   }
  // }
  Future<bool> login() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final dio = ref.read(dioProvider);

      // Ensure your baseUrl in dioProvider is exactly: http://192.168.8.157:3000/api/v1
      // and this path matches your backend route
      final response = await dio.post(
        '/auth/login',
        data: {'email': state.email.trim(), 'password': state.password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['user'] ?? response.data['data'];
        final loggedInUser = UserModel.fromJson(userData);
        ref.read(userProvider.notifier).setUser(loggedInUser);
        return true;
      }
      return false;
    } on DioException catch (e) {
      // THIS PREVENTS THE FREEZE
      String msg = "Incorrect credentials"; // Default design message

      if (e.response?.statusCode == 404) {
        msg = "Endpoint not found (404). Check API path.";
      } else if (e.response?.data != null) {
        msg = e.response?.data['message'] ?? "Incorrect credentials";
      }

      state = state.copyWith(error: msg);
      return false;
    } catch (e) {
      state = state.copyWith(error: "Connection error");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref),
);
// final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
//   (ref) => LoginNotifier(ref),
// );
