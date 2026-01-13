import 'package:flutter_riverpod/flutter_riverpod.dart';

// This keeps track of the current tab index globally
final navigationIndexProvider = StateProvider<int>((ref) => 0);
