// providers/categories/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/category_model.dart';
import '../../service/category_api.dart';

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
      CategoryNotifier.new,
    );

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    final api = ref.watch(categoryApiProvider);
    return api.fetchCategories();
  }

  /// 🔄 Pull-to-refresh support
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

// The Subscription Provider
final categorySubscriptionProvider =
    StateNotifierProvider<CategorySubscriptionNotifier, Set<String>>((ref) {
      return CategorySubscriptionNotifier();
    });

class CategorySubscriptionNotifier extends StateNotifier<Set<String>> {
  CategorySubscriptionNotifier() : super({});

  // Named 'toggle' to fix your undefined_method error
  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state}..add(id);
    }
  }
}
