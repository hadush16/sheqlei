// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/providers/filter_provider.dart';

// class TagChips extends ConsumerWidget {
//   final List<String> tags;
//   const TagChips({super.key, required this.tags});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedTags = ref.watch(filterSelectionProvider).selectedTags;

//     return Wrap(
//       spacing: 8,
//       children: tags.map((tag) {
//         final isSelected = selectedTags.contains(tag);
//         return FilterChip(
//           label: Text(tag),
//           selected: isSelected,
//           onSelected: (_) =>
//               ref.read(filterSelectionProvider.notifier).toggleTag(tag),
//           selectedColor: Colors.deepPurple.shade100,
//           checkmarkColor: Colors.deepPurple,
//         );
//       }).toList(),
//     );
//   }
// }
