import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/professional/providers/subscription/app_subscription_provider.dart';

class AppSubscribeBell extends ConsumerWidget {
  final String id;
  final String type; // e.g., 'tag', 'category', 'company'
  final double size;

  const AppSubscribeBell({
    super.key,
    required this.id,
    required this.type,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Combine type and id to create a truly unique key
    final uniqueKey = "${type}_$id";
    final isSubscribed = ref.watch(globalSubscriptionProvider(uniqueKey));

    return GestureDetector(
      onTap: () {
        // Toggle the local state immediately
        ref.read(globalSubscriptionProvider(uniqueKey).notifier).toggle();

        // You can now trigger different logic based on the type!
        _handleExternalLogic(type, id, !isSubscribed);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          isSubscribed
              ? 'assets/icons/bell-ring-solid.svg'
              : 'assets/icons/bell-ring-outline.svg',
          width: size,
          colorFilter: ColorFilter.mode(
            isSubscribed ? const Color(0xffa06cd5) : Color(0xff8967B3),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  // This is where you pass different ways for different functions
  void _handleExternalLogic(String type, String id, bool newState) {
    print(
      "Logic for $type ($id): Now is ${newState ? 'Subscribed' : 'Unsubscribed'}",
    );
    // Example: if (type == 'tag') callTagApi();
  }
}
