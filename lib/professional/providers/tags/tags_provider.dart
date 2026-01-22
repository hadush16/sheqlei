import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tag_provider_for_jobcount.dart';

final tagsListProvider = FutureProvider.autoDispose<List<Tag>>((ref) async {
  final List<dynamic> rawData = await ref.watch(tagApiProvider).fetchTags();

  return rawData.map((item) {
    // If the backend doesn't provide it, we create a fallback string
    return Tag(
      id: item['_id'] ?? '',
      name: item['name'] ?? 'Unknown',
      // FIX: Use slug or a custom string since description doesn't exist in DB
      description: "Explore all jobs tagged under ${item['name']}.",
      totalJobs: 0, // Stays 0 because route /tags/:id is 404
      totalSubscribers: 0,
    );
  }).toList();
});
