import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/category_model.dart';
//import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/service/job_api.dart';
import '../../models/filter_model.dart';
// IMPORTANT: Import the file where your mockTags and mockCategories are located
// import 'package:sheqlee/data/mock_data.dart';

// --- SEARCH STATE LOGIC ---

class FilterSearchState {
  final String searchQuery;
  final String? activeCategoryId; // Define this
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
      activeCategoryId: activeCategoryId ?? this.activeCategoryId,
      activeTagId: activeTagId ?? this.activeTagId,
    );
  }
}

class FilterSearchNotifier extends Notifier<FilterSearchState> {
  @override
  FilterSearchState build() => FilterSearchState();

  // void setSearchTag(String tagId) {
  //   state = state.copyWith(activeTagId: tagId, activeCategoryId: null);
  // }
  // FIX: When setting a Tag, clear the Category and Search Query
  void setSearchTag(String tagId) {
    // Reset everything else when searching by a specific Tag ID
    state = FilterSearchState(activeTagId: tagId);
  }

  void setSearchCategory(String categoryId) {
    // Clear the search query and tag when a category is selected from the dropdown
    state = state.copyWith(activeCategoryId: categoryId, activeTagId: null);
  }

  void updateQuery(String query) {
    // Clear category and tag when the user types a manual search
    state = FilterSearchState(searchQuery: query);
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
// final filterDataProvider = FutureProvider<FilterData>((ref) async {
//   // Simulate a slight delay to mimic a database call
//   await Future.delayed(const Duration(milliseconds: 300));

//   // Return the FilterData using your imported mock lists
//   return FilterData(tags: mockTags, categories: mockCategories);
// }
// );
// This fetches data from your BACKEND instead of mock_data.dart
final filterDataProvider = FutureProvider<FilterData>((ref) async {
  // This calls the new methods we just added to JobApi
  final categories = await JobApi.fetchCategories();
  final tags = await JobApi.fetchTags();

  return FilterData(categories: categories, tags: tags);
});

// For your dropdowns or other parts of the app
final jobCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  return await JobApi.fetchCategories();
});
