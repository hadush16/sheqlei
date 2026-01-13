import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/providers/bottomnavigation/navigation_provider.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(navigationIndexProvider.notifier).state = index;
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff8967B3),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/home - outline.svg'),
          activeIcon: SvgPicture.asset('assets/icons/home - solid.svg'),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/activity - outline.svg'),
          activeIcon: SvgPicture.asset('assets/icons/activity - solid.svg'),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/heart - outline.svg'),
          activeIcon: SvgPicture.asset('assets/icons/heart - solid (2).svg'),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/user - outline.svg'),
          activeIcon: SvgPicture.asset('assets/icons/user - solid.svg'),
          label: "Account",
        ),
      ],
    );
  }
}
