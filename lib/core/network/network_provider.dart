import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AppNetworkClient {
  // Use http:// NOT https:// for local IPs
  final String baseUrl = 'http://192.168.0.109:3000/api/v1';

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5)); // Stops the "Freeze" after 5s

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));

      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': decoded};
    }
    return {'success': false, 'message': decoded['message'] ?? 'Error'};
  }

  Map<String, dynamic> _handleError(dynamic e) {
    // This prevents the app from pausing/freezing
    print("Network log: $e");
    return {'success': false, 'message': 'Connection failed'};
  }
}

final httpClientProvider = Provider((ref) => AppNetworkClient());
