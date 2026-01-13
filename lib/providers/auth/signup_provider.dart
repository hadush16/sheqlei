import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/auth_service.dart';

// This handles the loading state and the registration logic
class SignUpNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  SignUpNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<bool> register(Map<String, dynamic> data, bool isCompany) async {
    state = const AsyncValue.loading();
    try {
      // Pass the raw map to the auth service
      await _authService.register(data, isCompany);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

// The Provider itself
final signUpProvider = StateNotifierProvider<SignUpNotifier, AsyncValue<void>>((
  ref,
) {
  return SignUpNotifier(AuthService());
});
