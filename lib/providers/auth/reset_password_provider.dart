import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordState {
  final String code;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool obscure;
  final String? backendError; // New field to capture API errors

  ResetPasswordState({
    this.code = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.obscure = true,
    this.backendError,
  });

  // FIXED LOGIC: Returning clear strings so AuthErrorIndicator can display them
  String? get currentError {
    if (backendError != null) return backendError;
    // if (code.isNotEmpty && code.length < 6) return "Code must be 6 digits";
    // if (password.isNotEmpty && password.length < 6) return "";
    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      return "password did not match"; // Matches your validator text
    }
    return null;
  }

  bool get isCodeValid => code.length == 6;
  bool get passwordsMatch => password == confirmPassword && password.isNotEmpty;
  bool get isPasswordLongEnough => password.length >= 6;
  bool get canSubmit => isCodeValid && passwordsMatch && isPasswordLongEnough;

  ResetPasswordState copyWith({
    String? code,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? obscure,
    String? backendError, // Added to copyWith
  }) {
    return ResetPasswordState(
      code: code ?? this.code,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      obscure: obscure ?? this.obscure,
      // We allow passing null to clear the backend error
      backendError: backendError,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier() : super(ResetPasswordState());

  void setCode(String val) =>
      state = state.copyWith(code: val, backendError: null);

  void setPassword(String val) =>
      state = state.copyWith(password: val, backendError: null);

  void setConfirmPassword(String val) =>
      state = state.copyWith(confirmPassword: val, backendError: null);

  void toggleObscure() => state = state.copyWith(obscure: !state.obscure);

  Future<bool> submitReset() async {
    // Prevent multiple clicks
    if (state.isLoading) return false;

    state = state.copyWith(isLoading: true, backendError: null);

    try {
      // Replace this with your actual MongoDB / Backend call
      // Example: await authService.reset(state.code, state.password);
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      // If backend fails, capture the error message here
      state = state.copyWith(isLoading: false, backendError: e.toString());
      return false;
    }
  }
}

final resetPasswordProvider =
    StateNotifierProvider.autoDispose<
      ResetPasswordNotifier,
      ResetPasswordState
    >((ref) => ResetPasswordNotifier());
