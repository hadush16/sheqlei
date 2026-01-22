// lib/providers/tags/tags_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/network_provider.dart';
import 'package:sheqlee/professional/service/tag_api.dart';

// Create a provider for the API class itself
final tagApiProvider = Provider((ref) => TagApi(ref.watch(httpClientProvider)));
// Main tags list
final tagsListProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return await ref.watch(tagApiProvider).fetchTags();
});

// Stats for the pills
final tagStatsProvider = FutureProvider.family<Map<String, int>, String>((
  ref,
  tagId,
) async {
  // Use the safe API call that returns 0 instead of 404ing
  final data = await ref.watch(tagApiProvider).fetchTagStats(tagId);

  return {'jobs': data['totalJobs'] ?? 0, 'subs': data['subscriberCount'] ?? 0};
});
