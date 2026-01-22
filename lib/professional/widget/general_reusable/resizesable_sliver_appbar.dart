import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/professional/screens/tags/tags_search_screen.dart';
import 'dart:ui';

import 'package:sheqlee/professional/widget/login/backbutton.dart';

// class DynamicSliverHeader extends SliverPersistentHeaderDelegate {
//   final String title;
//   final bool showSearch; // Add this

//   DynamicSliverHeader({required this.title, required this.showSearch});

//   @override
//   // Reduced maxExtent slightly to avoid being cut off on smaller viewports
//   double get maxExtent => 160.0;

//   @override
//   // Ensure minExtent is small enough to fit any screen but large enough for the button
//   double get minExtent => 100;

//   @override
//   bool shouldRebuild(covariant DynamicSliverHeader oldDelegate) =>
//       title != oldDelegate.title;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     // Current available height based on scroll
//     final double currentHeight = (maxExtent - shrinkOffset).clamp(
//       minExtent,
//       maxExtent,
//     );
//     final double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(
//       0.0,
//       1.0,
//     );

//     // Dynamics for positioning
//     final double currentTop = lerpDouble(95, 50, progress)!;
//     final double currentHorizontal = lerpDouble(25, 20, progress)!;
//     const double fixedHorizontalPadding = 25.0;
//     return Material(
//       color: Colors.white, // Forces background to white
//       surfaceTintColor: Colors.white,
//       child: Container(
//         height: currentHeight,
//         color: Colors.white,
//         child: Material(
//           color: Colors.transparent,
//           // elevation: progress > 0.9
//           //     ? 0.5
//           //     : 0, // Only show shadow when fully collapsed
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: currentTop,
//                   left: fixedHorizontalPadding,
//                   right: fixedHorizontalPadding,
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment
//                       .start, // Keep items at the top of the padding
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0),
//                           child: const AppBackButton(),
//                         ),
//                         const SizedBox(width: 60),
//                         Text(
//                           title,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: lerpDouble(19, 17, progress),
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'pretendard',
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (showSearch)
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => TagSearchScreen(),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             top: 5,
//                           ), // Align icon with text
//                           child: SvgPicture.asset(
//                             'assets/icons/search-alt2 (1).svg',
//                             width: 22,
//                             colorFilter: const ColorFilter.mode(
//                               Color(0xffa06cd5),
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   double? lerpDouble(num a, num b, double t) => a + (b - a) * t;
// }
class DynamicSliverHeader extends SliverPersistentHeaderDelegate {
  final String title;
  final bool showSearch;

  DynamicSliverHeader({required this.title, required this.showSearch});

  @override
  double get maxExtent => 160.0;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant DynamicSliverHeader oldDelegate) =>
      title != oldDelegate.title || showSearch != oldDelegate.showSearch;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double currentHeight = (maxExtent - shrinkOffset).clamp(
      minExtent,
      maxExtent,
    );
    final double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(
      0.0,
      1.0,
    );

    final double currentTop = lerpDouble(95, 50, progress)!;
    const double fixedHorizontalPadding = 25.0;

    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        height: currentHeight,
        color: Colors.white,
        padding: EdgeInsets.only(
          top: currentTop,
          left: fixedHorizontalPadding,
          right: fixedHorizontalPadding,
        ),
        // We use a StatefulWidget here to handle the toggle between Title and Search
        child: HeaderContentRow(
          title: title,
          showSearch: showSearch,
          progress: progress,
        ),
      ),
    );
  }

  double? lerpDouble(num a, num b, double t) => a + (b - a) * t;
}

class HeaderContentRow extends StatefulWidget {
  final String title;
  final bool showSearch;
  final double progress;

  const HeaderContentRow({
    super.key,
    required this.title,
    required this.showSearch,
    required this.progress,
  });

  @override
  State<HeaderContentRow> createState() => _HeaderContentRowState();
}

class _HeaderContentRowState extends State<HeaderContentRow> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Back Button - Always stays on the left
        const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: AppBackButton(),
        ),

        const SizedBox(
          width: 20,
        ), // Reduced from 60 to allow room for TextField
        // 2. Center Piece (Title or Search Field)
        Expanded(
          child: isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search tags...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontFamily: 'pretendard',
                      fontSize: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: widget.progress > 0.5
                        ? 17
                        : 19, // Smooth size transition
                    fontWeight: FontWeight.w600,
                    fontFamily: 'pretendard',
                  ),
                ),
        ),

        // 3. Right Action (Search Icon or Cancel Text)
        // if (widget.showSearch)
        //   GestureDetector(
        //     onTap: () {
        //       // Instead of toggling local state, navigate to the search screen
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const TagSearchScreen(),
        //         ),
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 2),
        //       child: isSearching
        //           ? const Text(
        //               "Cancel",
        //               style: TextStyle(
        //                 color: Color(0xffa06cd5),
        //                 fontWeight: FontWeight.w600,
        //                 fontFamily: 'pretendard',
        //               ),
        //             )
        //           : SvgPicture.asset(
        //               'assets/icons/search-alt2 (1).svg',
        //               width: 22,
        //               colorFilter: const ColorFilter.mode(
        //                 Color(0xffa06cd5),
        //                 BlendMode.srcIn,
        //               ),
        //             ),
        //     ),
        //   ),
        // 3. Right Action (Search Icon or Cancel Text)
        if (widget.showSearch)
          GestureDetector(
            onTap: () {
              setState(() {
                isSearching = !isSearching;
                if (isSearching) {
                  // Optional: If you still want to navigate to the separate screen
                  // when the icon is tapped, keep the Navigator here.
                  // Otherwise, just use the local toggle below.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TagSearchScreen(),
                    ),
                  ).then((_) {
                    // When returning from the search screen, reset the icon state
                    setState(() => isSearching = false);
                  });
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: isSearching
                  ? const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xffa06cd5),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'pretendard',
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/icons/search-alt2 (1).svg',
                      width: 22,
                      colorFilter: const ColorFilter.mode(
                        Color(0xffa06cd5),
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
