import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/models/filter_model.dart'; // Adjust this to your model path

final jobCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  // We use 'async' to wrap the list in a Future automatically.
  // This simulates a network call and fixes the 'invalid_type_from_closure' error.

  // Optional: Add a tiny delay to see your loading shimmer/spinner
  await Future.delayed(const Duration(milliseconds: 200));

  return mockCategories;
});
