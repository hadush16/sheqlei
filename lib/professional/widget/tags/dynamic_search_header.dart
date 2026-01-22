// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sheqlee/screens/tags/tags_search_screen.dart';

// class DynamicSliverHeader extends SliverPersistentHeaderDelegate {
//   final String title;
//   final bool showSearch;

//   DynamicSliverHeader({required this.title, required this.showSearch});

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     // Wrap in a SizedBox with a FIXED height that matches maxExtent
//     return SizedBox(
//       height: 70,
//       child: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             if (showSearch)
//               GestureDetector(
//                 onTap: () {
//                   // Using push instead of pushReplacement is usually better for search
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => TagSearchScreen()),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 5),
//                   child: SvgPicture.asset(
//                     'assets/icons/search-alt2 (1).svg',
//                     width: 22,
//                     colorFilter: const ColorFilter.mode(
//                       Color(0xffa06cd5),
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 70.0; // Ensure this is exactly 70.0

//   @override
//   double get minExtent => 70.0; // Ensure this is exactly 70.0

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
//       true;
// }
