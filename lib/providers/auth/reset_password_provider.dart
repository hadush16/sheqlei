import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordState {
  final String code;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool obscure;

  ResetPasswordState({
    this.code = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.obscure = true,
  });

  // LOGIC LIVES HERE - The UI watches this
  String? get currentError {
    if (code.isNotEmpty && code.length < 6) return "";
    if (password.isNotEmpty && password.length < 6) return "";
    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      return "Passwords don't match";
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
  }) {
    return ResetPasswordState(
      code: code ?? this.code,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      obscure: obscure ?? this.obscure,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier() : super(ResetPasswordState());

  void setCode(String val) => state = state.copyWith(code: val);
  void setPassword(String val) => state = state.copyWith(password: val);
  void setConfirmPassword(String val) =>
      state = state.copyWith(confirmPassword: val);
  void toggleObscure() => state = state.copyWith(obscure: !state.obscure);

  Future<bool> submitReset() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
    return true;
  }
}

final resetPasswordProvider =
    StateNotifierProvider.autoDispose<
      ResetPasswordNotifier,
      ResetPasswordState
    >((ref) => ResetPasswordNotifier());
