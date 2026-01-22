import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/providers/profile/edit_profile_provider.dart';
import 'package:sheqlee/professional/screens/profile/edit_profile.dart';
import 'package:sheqlee/professional/widget/profile/app_avatar.dart';
import 'package:sheqlee/professional/providers/user/user_provider.dart'; // <--- Check this path

class AppSliverHeader extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  //final String username;

  const AppSliverHeader({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final profile = ref.watch(profileProvider);
    final userAsync = ref.watch(userProvider);
    return SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      pinned: true,
      expandedHeight: 140,
      collapsedHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = ((170.0 - constraints.biggest.height) / (170.0 - 80.0))
              .clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    // Transform.scale(
                    //   scale: 0.9 - (0.1 * t),
                    //   child: AppAvatar(
                    //     radius: size.width * 0.09,
                    //     // imageUrl would come from your backend once ready
                    //     imageUrl: null,
                    //     // This is the field from your ProfileState
                    //     localFilePath: profile.profileImagePath,
                    //   ),
                    // ),
                    // Inside your AppSliverHeader class...
                    // Find the AppAvatar and wrap it like this:
                    // TAP TRIGGER FOR DRAWER
                    GestureDetector(
                      onTap: () {
                        // Open the drawer using the GlobalKey
                        if (scaffoldKey?.currentState != null) {
                          scaffoldKey!.currentState!.openDrawer();
                        } else {
                          // Fallback if key wasn't passed correctly
                          Scaffold.of(context).openDrawer();
                        }
                      },
                      child: Transform.scale(
                        scale: 0.9 - (0.1 * t),
                        child: AppAvatar(
                          radius: size.width * 0.09,
                          imageUrl: null,
                          localFilePath: profile.profileImagePath,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(
                        //   "Welcome, $username",
                        //   style: TextStyle(
                        //     fontSize: lerpDouble(size.width * 0.05, 10, t),
                        //     fontWeight: FontWeight.bold,
                        //     fontFamily: 'pretendard',
                        //   ),
                        // ),
                        // 2. DYNAMIC USERNAME LOGIC
                        userAsync.when(
                          data: (user) => Text(
                            style: TextStyle(
                              fontSize: lerpDouble(size.width * 0.06, 10, t),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'pretendard',
                            ),
                            "Welcome, ${user?.name ?? 'Muruts Yifter'}",
                          ),
                          loading: () => const Text("Welcome..."),
                          error: (err, stack) => const Text("Welcome!"),
                        ),
                        if (t < 0.5) // Only show when expanded
                          TextButton(
                            child: Text(
                              "Edit profile",
                              style: TextStyle(
                                color: const Color(0xffa06cd5),
                                fontSize: 12,
                                fontFamily: 'pretendard',
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
