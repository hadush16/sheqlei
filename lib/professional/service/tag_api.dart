import 'package:flutter/material.dart';
import 'package:sheqlee/core/network/network_provider.dart';

class TagApi {
  final AppNetworkClient _client; 

  // FIX: Constructor matches the class variable name
  TagApi(this._client);

  Future<List<dynamic>> fetchTags() async {
    try {
      // Use the new client GET (returns a Map, not a Dio Response)
      final result = await _client.get('/tags');

      // Check the 'success' flag from your AppNetworkClient
      if (result['success'] == true && result['data'] != null) {
        // Accessing data following your backend structure: data -> data -> tags
        return result['data']['data']['tags'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      // Catching all errors here stops the "Pause" or "Freeze"
      debugPrint("Tag Fetch Error: $e");
      return []; 
    }
  }

  Future<Map<String, dynamic>> fetchTagStats(String tagId) async {
    try {
      // Using your client to call the specific tag endpoint
      final result = await _client.get('/tags/$tagId');

      if (result['success'] == true && result['data'] != null) {
        return result['data']['data'] ?? {'totalJobs': 0, 'subscriberCount': 0};
      }

      // If success is false (e.g., 404), return default values silently
      return {'totalJobs': 0, 'subscriberCount': 0};
    } catch (e) {
      // If it fails, return 0 instead of crashing/pausing
      return {'totalJobs': 0, 'subscriberCount': 0};
    }
  }
}