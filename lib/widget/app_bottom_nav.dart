import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xffa06cd5);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: activeColor,
      unselectedItemColor: Colors.black87,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: [
        _buildItem('home - solid.svg', 'Home', 0),
        _buildItem('activity - outline.svg', 'Dashboard', 1),
        _buildItem('heart - outline.svg', 'Favorites', 2),
        _buildItem('user - outline.svg', 'Account', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildItem(String iconName, String label, int index) {
    final bool selected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: SvgPicture.asset(
          'assets/icons/$iconName',
          color: selected ? const Color(0xffa06cd5) : Colors.black,
          // Dynamically change the color of the SVG based on active state
          // colorFilter: ColorFilter.mode(
          //   isActive ? const Color(0xffa06cd5) : Color(0x00000000),
          //   BlendMode.srcIn,
          // ),
        ),
      ),
      label: label,
    );
  }
}
