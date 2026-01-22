import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/network_provider.dart';
import 'package:sheqlee/professional/models/user_model.dart';
import 'package:sheqlee/professional/providers/user/user_provider.dart';

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
      // 1. Read the new http client provider
      final client = ref.read(httpClientProvider);

      // 2. Use client.post which returns a Map
      final result = await client.post('/auth/login', {
        'email': state.email.trim(),
        'password': state.password,
      });

      if (result['success'] == true) {
        final responseData = result['data'];
        final userData = responseData['user'] ?? responseData['data'];

        final loggedInUser = UserModel.fromJson(userData);
        ref.read(userProvider.notifier).setUser(loggedInUser);
        return true;
      } else {
        // 3. Handled error from your client (stops the freeze)
        state = state.copyWith(
          error: result['message'] ?? "Incorrect credentials",
        );
        return false;
      }
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
