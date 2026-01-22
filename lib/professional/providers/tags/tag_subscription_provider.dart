// lib/providers/tags/tag_subscription_provider.dart

// A set of tag IDs that are subscribed to
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagSubscriptionNotifier extends StateNotifier<Set<String>> {
  TagSubscriptionNotifier() : super({});

  void toggleSubscription(String tagId) {
    if (state.contains(tagId)) {
      state = {...state}..remove(tagId);
    } else {
      state = {...state}..add(tagId);
    }
  }

  bool isSubscribed(String tagId) => state.contains(tagId);
}

final tagSubscriptionProvider =
    StateNotifierProvider<TagSubscriptionNotifier, Set<String>>((ref) {
      return TagSubscriptionNotifier();
    });
