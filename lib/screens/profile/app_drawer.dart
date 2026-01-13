import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/models/user_model.dart';
import 'package:sheqlee/providers/user/user_provider.dart';
import 'package:sheqlee/screens/categories/categoreis_screen.dart';
import 'package:sheqlee/screens/companies/companies_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the profileProvider we created earlier
    final userAsync = ref.watch(userProvider);

    return Drawer(
      backgroundColor: Colors.white,
      // Removes the default rounded corners to match the sharp design
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // 1. Profile Header Section
          _buildHeader(userAsync),
          const Divider(height: 1, thickness: 1),

          // 2. Scrollable Menu List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerTile(
                  SvgPicture.asset('assets/icons/companies.svg'),
                  'Companies',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/categories.svg'),
                  'Categories',

                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryScreen()),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/tag (2).svg'),
                  'Tags',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/info.svg'),
                  'About',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),

                _drawerTile(
                  SvgPicture.asset('assets/icons/pages.svg'),
                  'Blog',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/tag - alt2.svg'),
                  'Pricing',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),

                _drawerTile(
                  SvgPicture.asset('assets/icons/rocket.svg'),
                  'Getting started',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/chat.svg'),
                  'Contact',
                  () {
                    // 1. Close the drawer first
                    Navigator.pop(context);
                    // 2. Navigate to the Companies Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompaniesScreen(),
                      ),
                    );
                  },
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/question-alt2.svg'),
                  'FAQ',
                  () {},
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/handshake.svg'),
                  'Terms of Service',
                  () {},
                ),
                _drawerTile(
                  SvgPicture.asset('assets/icons/insurance.svg'),
                  'Privacy Policy',
                  () {},
                ),
              ],
            ),
          ),

          // 3. Bottom Social Media & Version Section
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue<UserModel?> userState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 58, 10, 20),
      alignment: Alignment.centerLeft,
      child: userState.when(
        data: (user) => Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xffF6F4F9),
              // Use ?. to safely access the profilePic
              backgroundImage: user?.profilePic != null
                  ? NetworkImage(user!.profilePic!)
                  : null,
              child: user?.profilePic == null
                  ? Image.asset('assets/icons/pexels-pixabay-220453@2x.png')
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Provide a fallback name if user is null
                Text(
                  user?.name ?? "Guest User",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'pretendard',

                    fontSize: 20,
                  ),
                ),
                // Provide a fallback account type
                Text(
                  user?.accountType.toUpperCase() ?? "VISITOR",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'pretendard',
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text("Profile Error"),
      ),
    );
  }

  Widget _drawerTile(Widget icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ListTile(
        leading: SizedBox(width: 17, height: 17, child: icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        trailing: const Icon(Icons.chevron_right, size: 26, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        children: [
          // The purple heart icon from your design

          // Social Media Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(SvgPicture.asset('assets/icons/facebook.svg')),
              _socialIcon(
                SvgPicture.asset('assets/icons/twitter.svg'),
              ), // For X/Twitter
              _socialIcon(
                SvgPicture.asset('assets/icons/instagram.svg'),
              ), // For Instagram
              _socialIcon(
                SvgPicture.asset('assets/icons/tik-tok.svg'),
              ), // For TikTok
              _socialIcon(
                SvgPicture.asset('assets/icons/telegram.svg'),
              ), // For Telegram
            ],
          ),
          const SizedBox(height: 8),

          // Version Number
          const Text(
            'v0.12.383',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(Widget icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: icon,
      ),
    );
  }
}
