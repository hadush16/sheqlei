// lib/providers/subscription_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionNotifier extends FamilyNotifier<bool, String> {
  @override
  bool build(String arg) {
    // 'arg' is your unique ID (e.g., "tag_123" or "cat_456")
    return false;
  }

  void toggle() {
    state = !state;
  }

  // You can call this to force a specific state from any function
  void setSubscription(bool value) {
    state = value;
  }
}

final globalSubscriptionProvider =
    NotifierProvider.family<SubscriptionNotifier, bool, String>(
      SubscriptionNotifier.new,
    );
