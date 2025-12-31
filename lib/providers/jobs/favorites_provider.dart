import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider keeps track of which Job IDs are favorited
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String jobId) {
    if (state.contains(jobId)) {
      state = {...state}..remove(jobId);
    } else {
      state = {...state}..add(jobId);
    }
  }

  bool isFavorite(String jobId) => state.contains(jobId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier();
  },
);
