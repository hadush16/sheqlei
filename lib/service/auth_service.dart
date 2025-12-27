import 'dart:developer';
import '../models/signup_request.dart';

class AuthService {
  Future<void> register(SignUpRequest request) async {
    // 🔹 MOCK API CALL
    await Future.delayed(const Duration(seconds: 1));

    log("REGISTER JSON:");
    log(request.toJson().toString());

    // Later replace with:
    // http.post(url, body: jsonEncode(request.toJson()))
  }
}
