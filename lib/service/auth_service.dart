import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthService {
  final String _userUrl = "http://192.168.8.157:3000/api/v1/auth/signup";
  final String _companyUrl =
      "http://192.168.8.157:3000/api/v1/auth/company-register";
  Future<void> register(Map<String, dynamic> data, bool isCompany) async {
    final url = isCompany ? _companyUrl : _userUrl;
    try {
      // 1. Declare 'response' inside the try block
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(data), // jsonEncode(request.toJson()),
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      // 2. The logic MUST be inside this block where 'response' is defined
      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        String errorMessage = "Something went wrong";
        try {
          final errorData = jsonDecode(response.body);
          // Adjust 'errorData['message']' to match your Node.js error key
          errorMessage = errorData['message'] ?? "Validation Error";
        } catch (_) {
          errorMessage = "Server Error: ${response.statusCode}";
        }
        throw errorMessage;
      }
    } catch (e) {
      log("AuthService Error: $e");
      // Rethrow the error so the UI/Notifier can catch it and show the SnackBar
      rethrow;
    }
  }
}
