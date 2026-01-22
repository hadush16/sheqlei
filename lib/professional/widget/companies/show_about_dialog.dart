// void _showAboutModal(BuildContext context, CompanyModel company) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => Container(
//       height: MediaQuery.of(context).size.height * 0.75, // Adjust height
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       padding: const EdgeInsets.all(25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header: Close Button
//           Align(
//             alignment: Alignment.topRight,
//             child: TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close", style: TextStyle(color: Colors.black)),
//             ),
//           ),
          
//           // Title and Copy Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   "About ${company.name}",
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               // COPY BUTTON WITH SVG
//               IconButton(
//                 onPressed: () {
//                   // Logic to copy text to clipboard
//                 },
//                 icon: SvgPicture.asset(
//                   'assets/icons/copy_icon.svg', // Ensure you have this SVG
//                   width: 22,
//                   colorFilter: const ColorFilter.mode(
//                     Color(0xffa06cd5),
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
          
//           // Scrollable Full Description
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Text(
//                 company.fullDescription, // Ensure your model has this field
//                 style: TextStyle(
//                   color: Colors.grey[800],
//                   height: 1.6,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }