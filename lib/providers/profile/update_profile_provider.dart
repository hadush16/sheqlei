import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model to hold the field data and error states
class ProfileState {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool hasAttemptedSubmit; // Add this

  ProfileState({
    this.fullName = 'Muruts Yifter',
    this.email = 'muruts.yifter@gmail.com',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.hasAttemptedSubmit = false, // Default to false
  });

  // Check if passwords match
  bool get passwordsMatch => password == confirmPassword;

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? hasAttemptedSubmit,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  void updateFullName(String val) => state = state.copyWith(fullName: val);
  void updateEmail(String val) => state = state.copyWith(email: val);
  void updatePassword(String val) => state = state.copyWith(password: val);
  void updateConfirmPassword(String val) =>
      state = state.copyWith(confirmPassword: val);

  // Future<void> saveSettings() async {
  //   if (!state.passwordsMatch) return;
  //   state = state.copyWith(isLoading: true);

  //   // Simulate API Call
  //   await Future.delayed(const Duration(seconds: 2));

  //   state = state.copyWith(isLoading: false);
  // }
  Future<void> saveSettings() async {
    // Now 'hasAttemptedSubmit' is recognized by copyWith!
    state = state.copyWith(hasAttemptedSubmit: true);

    if (state.password != state.confirmPassword) {
      return; // Stop here, UI will now show the error
    }

    state = state.copyWith(isLoading: true);
    // ... rest of your code
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});
