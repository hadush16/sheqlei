import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/bottomnavigation/navigation_provider.dart';
import 'package:sheqlee/providers/user/user_provider.dart';
import 'package:sheqlee/screens/dashboard/dashbord.dart';
import 'package:sheqlee/screens/favorite/favorites_screen.dart';
import 'package:sheqlee/screens/profile/update_profile_screen.dart';
import 'package:sheqlee/widget/home/app_bottom_nav.dart';
import 'home_page.dart';

// class MainShellScreen extends ConsumerStatefulWidget {
//   //final String username;
//   const MainShellScreen({super.key});

//   @override
//   ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
// }

// class _MainShellScreenState extends ConsumerState<MainShellScreen> {
//   //int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final selectedIndex = ref.watch(navigationIndexProvider);
//     // 1. WATCH THE USER DATA
//     final userAsync = ref.watch(userProvider);

//     // 2. EXTRACT USERNAME SAFELY
//     final String currentUsername = userAsync.when(
//       data: (user) => user?.username ?? "Muruts Yifter",
//       loading: () => "Loading...",
//       error: (_, __) => "Error",
//     );
//     final List<Widget> _screens = [
//       HomePage(username: currentUsername),
//       DashboardScreen(),
//       const FavoritesScreen(),
//       const Center(child: Text("Account")),
//     ];
//     return Scaffold(
//       // 1. THE BODY (HomePage lives here)
//       body: IndexedStack(index: selectedIndex, children: _screens),
//       // 3. THE BOTTOM NAV BAR
//       bottomNavigationBar: AppBottomNavBar(
//         currentIndex: selectedIndex,
//         onTap: (index) {
//           ref.read(navigationIndexProvider.notifier).state = index;
//         },
//       ),
//     );
//   }
// }
class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    // Safety: Get username for HomePage
    final userAsync = ref.watch(userProvider);
    final String currentUsername = userAsync.maybeWhen(
      data: (user) => user?.name ?? "User",
      orElse: () => "User",
    );

    final List<Widget> screens = [
      HomePage(username: currentUsername),
      const DashboardScreen(), // This uses your filteredJobsProvider
      const FavoritesScreen(),
      const UpdateProfileScreen(),
    ];

    return Scaffold(
      // IndexedStack keeps your scroll position alive when switching tabs
      body: IndexedStack(index: selectedIndex, children: screens),
      // Just call the reusable bar here
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
