import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/filter_model.dart';

// 1. Fetching Data (MongoDB Placeholder)
final filterDataProvider = FutureProvider<FilterData>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));

  final mockJson = {
    "tags": [
      {"_id": "t1", "name": "Java"},
      {"_id": "t2", "name": "Python"},
      {"_id": "t3", "name": "c++"},
      {"_id": "t4", "name": "JavaScript"},
      {"_id": "t5", "name": "Rust"},
      {"_id": "t6", "name": "C#"},
      {"_id": "t7", "name": "ASP .NET"},
      {"_id": "t8", "name": "TypeScript"},
      {"_id": "t9", "name": "Flutter"},
      {"_id": "t10", "name": "React.js"},
    ],
    "categories": [
      {
        "_id": "c1",
        "name": "Mobile Development",
        "tagIds": ["t10", "t9", "t1"],
      },
      {
        "_id": "c2",
        "name": "Product Design",
        "tagIds": ["t3"],
      },
      {
        "_id": "c3",
        "name": "Machine Learning",
        "tagIds": ["t3", "t4"],
      },
      {
        "_id": "c4",
        "name": "QA & DevOps",
        "tagIds": ["t3"],
      },
      {
        "_id": "c5",
        "name": "Web Frontend Development",
        "tagIds": ["t3", "t1", "t10", "t4", "t8"],
      },
      {
        "_id": "c6",
        "name": "Cyber Security",
        "tagIds": ["t3"],
      },
      {
        "_id": "c7",
        "name": "Full-Stack Development",
        "tagIds": ["t3"],
      },
      {
        "_id": "c8",
        "name": "System & Business Analysis",
        "tagIds": ["t3"],
      },
      {
        "_id": "c9",
        "name": "Project Management",
        "tagIds": ["t3"],
      },
    ],
  };

  return FilterData(
    tags: (mockJson['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
    categories: (mockJson['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList(),
  );
});

// 2. Selection State
class FilterState {
  final Set<String> selectedTagIds;
  final String? selectedCategoryId;
  FilterState({this.selectedTagIds = const {}, this.selectedCategoryId});

  FilterState copyWith({
    Set<String>? selectedTagIds,
    String? selectedCategoryId,
  }) {
    return FilterState(
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class FilterNotifier extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  void toggleTag(String tagId) {
    final newTags = Set<String>.from(state.selectedTagIds);
    if (newTags.contains(tagId)) {
      newTags.remove(tagId);
    } else {
      newTags.add(tagId);
    }
    state = state.copyWith(selectedTagIds: newTags);
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }
}

final filterSelectionProvider = NotifierProvider<FilterNotifier, FilterState>(
  FilterNotifier.new,
);
