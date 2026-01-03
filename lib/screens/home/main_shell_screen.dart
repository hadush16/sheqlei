import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/providers/user/user_provider.dart';
import 'package:sheqlee/screens/home/favorites_screen.dart';
import 'package:sheqlee/screens/home/filter_page.dart';
import 'package:sheqlee/widget/home/app_bottom_nav.dart';
import 'home_page.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  //final String username;
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. WATCH THE USER DATA
    final userAsync = ref.watch(userProvider);

    // 2. EXTRACT USERNAME SAFELY
    final String currentUsername = userAsync.when(
      data: (user) => user?.username ?? "Muruts Yifter",
      loading: () => "Loading...",
      error: (_, __) => "Error",
    );
    final List<Widget> pages = [
      HomePage(username: currentUsername),
      const Center(child: Text("Dashboard")),
      const FavoritesScreen(),
      const Center(child: Text("Account")),
    ];
    return Scaffold(
      // 1. THE BODY (HomePage lives here)
      body: IndexedStack(index: _currentIndex, children: pages),

      // 2. THE FLOATING BUTTON
      // We show it only when _currentIndex is 0 (Home)
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xff8967B3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              ),
              child: SvgPicture.asset(
                'assets/icons/search-alt2.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,

      // 3. THE BOTTOM NAV BAR
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
