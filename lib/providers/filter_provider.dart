import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/data/mock_data.dart';
import '../models/filter_model.dart';
// IMPORTANT: Import the file where your mockTags and mockCategories are located
// import 'package:sheqlee/data/mock_data.dart';

// --- SEARCH STATE LOGIC ---

class FilterSearchState {
  final String searchQuery;
  final String? activeCategoryId;
  final String? activeTagId;

  FilterSearchState({
    this.searchQuery = "",
    this.activeCategoryId,
    this.activeTagId,
  });

  FilterSearchState copyWith({
    String? searchQuery,
    String? activeCategoryId,
    String? activeTagId,
  }) {
    return FilterSearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      activeCategoryId: activeCategoryId,
      activeTagId: activeTagId,
    );
  }
}

class FilterSearchNotifier extends Notifier<FilterSearchState> {
  @override
  FilterSearchState build() => FilterSearchState();

  void setSearchTag(String tagId) {
    state = state.copyWith(activeTagId: tagId, activeCategoryId: null);
  }

  void setSearchCategory(String categoryId) {
    state = state.copyWith(activeCategoryId: categoryId, activeTagId: null);
  }

  void updateQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = FilterSearchState();
  }
}

final filterSearchProvider =
    NotifierProvider<FilterSearchNotifier, FilterSearchState>(
      FilterSearchNotifier.new,
    );

// --- THE MISSING PROVIDER (FIXES YOUR ERROR) ---

// This provider takes your mock data and makes it available to the UI
final filterDataProvider = FutureProvider<FilterData>((ref) async {
  // Simulate a slight delay to mimic a database call
  await Future.delayed(const Duration(milliseconds: 300));

  // Return the FilterData using your imported mock lists
  return FilterData(tags: mockTags, categories: mockCategories);
});
