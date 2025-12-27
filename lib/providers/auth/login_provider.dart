import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  LoginNotifier() : super(const LoginState());

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
  Future<bool> login() async {
    // Access the values already stored in the state
    final currentEmail = state.email;
    final currentPassword = state.password;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 🔐 Use currentEmail and currentPassword for your API call
      await Future.delayed(const Duration(seconds: 2));

      // For demonstration: simulate a credential check
      if (currentEmail == "hadush@gmail.com" && currentPassword == "12345678") {
        return true;
      } else {
        state = state.copyWith(
          error: "The credentials you entered are incorrect.",
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: "Network error, please try again.");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);
