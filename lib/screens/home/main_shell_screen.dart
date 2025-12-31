import 'package:flutter/material.dart';
import 'package:sheqlee/screens/home/favorites_screen.dart';
import 'package:sheqlee/widget/app_bottom_nav.dart';
import 'home_page.dart'; // Import your HomePage file

class MainShellScreen extends StatefulWidget {
  final String username;
  const MainShellScreen({super.key, required this.username});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens for each tab
    final List<Widget> pages = [
      HomePage(username: widget.username),
      const Scaffold(body: Center(child: Text("Dashboard"))),
      const Scaffold(body: FavoritesScreen()),
      const Scaffold(body: Center(child: Text("Account"))),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
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
