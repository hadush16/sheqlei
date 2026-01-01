import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/providers/filter_provider.dart';

class TagSearchGroup extends ConsumerWidget {
  final List<Tag> tags;

  const TagSearchGroup({super.key, required this.tags});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the active tag ID to highlight the current search
    final activeTagId = ref.watch(filterSearchProvider).activeTagId;

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: tags.map((tag) {
        final isSelected = activeTagId == tag.id;

        return GestureDetector(
          onTap: () {
            // Set the global search to this Tag ID
            ref.read(filterSearchProvider.notifier).setSearchTag(tag.id);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xffa06cd5).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isSelected ? const Color(0xffa06cd5) : Colors.black,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              tag.name,
              style: TextStyle(
                color: isSelected ? const Color(0xffa06cd5) : Colors.black,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
