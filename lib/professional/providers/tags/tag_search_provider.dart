// lib/providers/tags/tag_search_provider.dart

// 1. Tracks whether the search bar is active
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tags_provider.dart';

// Tracks what the user is typing
final tagSearchQueryProvider = StateProvider<String>((ref) => "");

// Filters the list of tags based on the query
final searchSuggestionsProvider = Provider<List<Tag>>((ref) {
  final query = ref.watch(tagSearchQueryProvider).toLowerCase();
  final allTags =
      ref.watch(tagsListProvider).value ?? []; // Your tags from DB/Mock

  if (query.isEmpty) return []; // Show nothing or "recent" if empty
  return allTags
      .where((tag) => tag.name.toLowerCase().contains(query))
      .toList();
});
