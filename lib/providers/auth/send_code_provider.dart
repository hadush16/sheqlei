import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordResetState {
  final String email;
  final bool loading;

  PasswordResetState({this.email = '', this.loading = false});

  PasswordResetState copyWith({String? email, bool? loading}) {
    return PasswordResetState(
      email: email ?? this.email,
      loading: loading ?? this.loading,
    );
  }
}

class PasswordResetNotifier extends StateNotifier<PasswordResetState> {
  PasswordResetNotifier() : super(PasswordResetState());

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  Future<void> sendResetCode() async {
    state = state.copyWith(loading: true);

    // 🔥 API / Firebase call here
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(loading: false);
  }
}

final passwordResetProvider =
    StateNotifierProvider<PasswordResetNotifier, PasswordResetState>(
      (ref) => PasswordResetNotifier(),
    );
