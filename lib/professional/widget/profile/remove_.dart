import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/professional/providers/profile/edit_profile_provider.dart';

Future<void> showGenericActionPopup<T>({
  required BuildContext context,
  required String title,
  required List<T> Function(ProfileState state) itemsSelector,
  required String Function(T) labelBuilder,
  required void Function(WidgetRef ref, T item) onActionPressed,
  // 1. Change 'required IconData actionIcon' to this:
  String actionIconPath = 'assets/icons/delete - alt2.svg',
  Color actionColor = Colors.redAccent,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      return Consumer(
        builder: (context, ref, child) {
          final profile = ref.watch(profileProvider);
          final items = itemsSelector(profile);

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: items.isEmpty
                  ? const Text("No items found.", textAlign: TextAlign.center)
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: items.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 201, 199, 199),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // ... (keep your decoration code)
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  labelBuilder(item),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => onActionPressed(ref, item),
                                // 2. Use the SVG path here
                                child: SvgPicture.asset(
                                  actionIconPath,
                                  width: 18,
                                  colorFilter: ColorFilter.mode(
                                    actionColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            // ...
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Center(child: Text("Done")),
              ),
            ],
          );
        },
      );
    },
  );
}
