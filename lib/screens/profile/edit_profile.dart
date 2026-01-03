// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/models/filter_model.dart';
// import 'package:sheqlee/models/job_level_model.dart';
// import 'package:sheqlee/providers/profile/edit_profile_provider.dart';
// import 'package:sheqlee/screens/profile/skill_popup.dart';
// import 'package:sheqlee/widget/login/backbutton.dart';
// import 'package:sheqlee/widget/profile/actionbutton.dart';
// import 'package:sheqlee/widget/profile/editable_text_form.dart';
// import 'package:sheqlee/widget/profile/level_indicator.dart';

// class EditProfilePage extends ConsumerWidget {
//   const EditProfilePage({super.key});
//   void _handleCVUpload(WidgetRef ref) {
//     // Logic to pick file goes here
//     // For now, we mock the result:
//     //ref.read(profileProvider.notifier).updateCV("");
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profile = ref.watch(profileProvider);
//     final addedSkills = profile.skills;
//     final addedLinks = profile.socialLinks;

//     return GestureDetector(
//       onTap: () {
//         // 2. This removes the current focus and hides the keyboard
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 120,
//               toolbarHeight:
//                   120, // Matches expanded to keep the row pinned at the 80px offset
//               backgroundColor: Colors.white,
//               elevation: 0,
//               scrolledUnderElevation: 0,
//               automaticallyImplyLeading: false,
//               flexibleSpace: LayoutBuilder(
//                 builder: (BuildContext context, BoxConstraints constraints) {
//                   double currentHeight = constraints.biggest.height;
//                   // 0.0 at 120px (expanded), 1.0 at 80px (collapsed area)
//                   double collapsePercent = ((120 - currentHeight) / 40).clamp(
//                     0.0,
//                     1.0,
//                   );

//                   // --- Precise Interpolations ---
//                   // Text: 16 -> 14
//                   double fontSize = 16 - (collapsePercent * 4);

//                   return FlexibleSpaceBar(
//                     titlePadding: EdgeInsets.zero,
//                     background: Container(color: Colors.white),
//                     title: Stack(
//                       children: [
//                         Positioned(
//                           top: 80, // Your fixed 80px from top
//                           left: 26, // Your fixed 26px from left
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // Sized back button icon
//                               SizedBox(
//                                 child: const FittedBox(
//                                   fit: BoxFit.fill,
//                                   child: AppBackButton(),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 "Edit Profile",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: fontSize,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // 2. Scrollable Content
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // --- PROFILE IMAGE ROW ---
//                     // This is now at the top of the scrollable area
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 40,
//                               backgroundColor: Colors.grey[200],
//                               backgroundImage: profile.profileImagePath != null
//                                   ? FileImage(File(profile.profileImagePath!))
//                                   : null,
//                               child: profile.profileImagePath == null
//                                   ? const Icon(
//                                       Icons.person,
//                                       size: 40,
//                                       color: Colors.grey,
//                                     )
//                                   : null,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: GestureDetector(
//                                 onTap: () => pickProfileImage(ref),
//                                 child: const CircleAvatar(
//                                   radius: 14,
//                                   backgroundColor: Color(0xff8967B3),
//                                   child: Icon(
//                                     Icons.add,
//                                     size: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 15),
//                         TextButton(
//                           onPressed: () => pickProfileImage(ref),
//                           child: const Text(
//                             "Add photo",
//                             style: TextStyle(
//                               color: Color(0xff8967B3),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     CustomProfileField(
//                       label: "Full name",
//                       hint: "Enter name",
//                       initialValue: profile.fullName,
//                       isRequired: true,
//                       onChanged: (v) =>
//                           ref.read(profileProvider.notifier).updateName(v),
//                     ),
//                     CustomProfileField(
//                       label: "Title",
//                       hint: "Professional headline",
//                       isRequired: true,
//                       onChanged: (v) =>
//                           ref.read(profileProvider.notifier).updateTitle(v),
//                     ),
//                     CustomProfileField(
//                       label: "Introduction",
//                       hint: "Tell us about yourself",
//                       maxLines: 4,
//                       maxLength: 256,
//                       onChanged: (v) =>
//                           ref.read(profileProvider.notifier).updateIntro(v),
//                     ),

//                     // --- SKILLS FIELD ---
//                     buildDisplayField(
//                       label: "Skills",
//                       content: Column(
//                         children: profile.skills
//                             .map(
//                               (skill) => Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 4,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       skill.tagName,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     // FIX: Now calling the class with 'level:' works perfectly
//                                     LevelIndicator(
//                                       level: int.tryParse(skill.levelId) ?? 1,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         // DESIGN: Remove button only appears if list is NOT empty
//                         if (addedSkills.isNotEmpty)
//                           ProfileActionButton(
//                             label: "Remove skill",
//                             onPressed: () =>
//                                 ref.read(profileProvider.notifier).removeSkill,
//                           ),
//                         const SizedBox(width: 8),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xff8967B3),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           onPressed: () => showSkillPopup(
//                             context,
//                             ref,
//                           ), // Call separate file
//                           child: const Text(
//                             "Add skill",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),

//                     // _buildAddButton(
//                     //   "Add skill",
//                     //   () => _showSkillPopup(context, ref),
//                     // ),
//                     const SizedBox(height: 10),

//                     // --- PROFILES FIELD ---
//                     _buildDisplayField(
//                       label: "Profiles",
//                       content: profile.socialLinks.isEmpty
//                           ? const Text(
//                               "No social links added",
//                               style: TextStyle(color: Colors.grey),
//                             )
//                           : Column(
//                               children: profile.socialLinks
//                                   .map(
//                                     (l) => ListTile(
//                                       dense: true,
//                                       contentPadding: EdgeInsets.zero,
//                                       leading: const Icon(Icons.link, size: 18),
//                                       title: Text(
//                                         l['platform']!,
//                                         style: const TextStyle(fontSize: 13),
//                                       ),
//                                       subtitle: Text(
//                                         l['url']!,
//                                         style: const TextStyle(
//                                           fontSize: 11,
//                                           color: Colors.blue,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                   .toList(),
//                             ),
//                     ),
//                     _buildAddButton(
//                       "Add profile",
//                       () => _showProfilePopup(context, ref),
//                     ),

//                     const SizedBox(height: 10),

//                     // --- CV FIELD ---
//                     // _buildDisplayField(
//                     //   label: "CV *",
//                     //   content: Row(
//                     //     children: [
//                     //       Icon(
//                     //         Icons.description,
//                     //         color: profile.cvFileName == null
//                     //             ? Colors.grey
//                     //             : Colors.redAccent,
//                     //       ),
//                     //       const SizedBox(width: 10),
//                     //       Expanded(
//                     //         child: Text(
//                     //           profile.cvFileName ?? "No CV uploaded",
//                     //           style: TextStyle(
//                     //             color: profile.cvFileName == null
//                     //                 ? Colors.grey
//                     //                 : Colors.black,
//                     //             fontWeight: profile.cvFileName == null
//                     //                 ? FontWeight.normal
//                     //                 : FontWeight.bold,
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     buildDisplayField(
//                       label: "CV",
//                       content: Text(
//                         profile.cvFileName ?? "No file selected",
//                         style: const TextStyle(
//                           color: Color(0xff4A90E2),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),

//                     // CHANGE: Call pickCV(ref) here
//                     _buildAddButton("Upload CV", () async => await pickCV(ref)),
//                     const SizedBox(height: 40),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         if (profile.cvFileName != null)
//                           ProfileActionButton(
//                             label: "Download",
//                             onPressed: () {
//                               /* Download Logic */
//                             },
//                           ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               // 1. Trigger the upload from the notifier
//                               final success = await ref
//                                   .read(profileProvider.notifier)
//                                   .uploadProfile();

//                               if (success) {
//                                 // 2. Show success message
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Profile Updated!"),
//                                   ),
//                                 );

//                                 // 3. Navigate back to Home
//                                 // Use pop() to go back to the previous screen in the stack
//                                 Navigator.pop(context);

//                                 // OR if you want to explicitly go to a Home route:
//                                 // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text("Upload failed. Try again."),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               minimumSize: const Size(double.infinity, 55),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: const Text(
//                               "Update profile",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 50),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDisplayField({required String label, required Widget content}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade400),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//             const SizedBox(height: 8),
//             content,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddButton(String label, VoidCallback onTap) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: WidgetStateProperty.all(Color(0xff8967B3)),
//         ),
//         onPressed: onTap,
//         //icon: const Icon(Icons.add, size: 18, color: Color(0xff8967B3)),
//         child: Text(label, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }

//   void _showProfilePopup(BuildContext context, WidgetRef ref) {
//     String p = '';
//     String u = '';
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Add Profile"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               onChanged: (v) => p = v,
//               decoration: const InputDecoration(hintText: "Platform"),
//             ),
//             TextField(
//               onChanged: (v) => u = v,
//               decoration: const InputDecoration(hintText: "URL"),
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               ref.read(profileProvider.notifier).addLink(p, u);
//               Navigator.pop(ctx);
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper for CV
//   Future<void> pickCV(WidgetRef ref) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: [
//           'pdf',
//           'doc',
//           'docx',
//         ], // Added docx for better compatibility
//       );

//       if (result != null && result.files.single.name.isNotEmpty) {
//         // Update the provider state with the file name
//         ref.read(profileProvider.notifier).updateCV(result.files.first.name);
//         print("File picked: ${result.files.first.name}");
//       } else {
//         // User canceled the picker
//         print("User canceled file picking");
//       }
//     } catch (e) {
//       print("Error picking CV: $e");
//     }
//   }

//   // Helper for Profile Image
//   Future<void> pickProfileImage(WidgetRef ref) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image, // Ensure this is set to image
//         allowCompression: true,
//       );

//       if (result != null && result.files.single.path != null) {
//         // We save the path (String) to the provider
//         ref
//             .read(profileProvider.notifier)
//             .updateProfileImage(result.files.single.path!);
//       }
//     } catch (e) {
//       debugPrint("Error picking image: $e");
//     }
//   }
// }

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/providers/profile/edit_profile_provider.dart';
import 'package:sheqlee/screens/home/home_page.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/screens/profile/skill_popup.dart';
import 'package:sheqlee/widget/login/app_primary_button.dart';
import 'package:sheqlee/widget/login/backbutton.dart';
import 'package:sheqlee/widget/profile/actionbutton.dart';
import 'package:sheqlee/widget/profile/editable_text_form.dart';
import 'package:sheqlee/widget/profile/level_indicator.dart';
import 'package:sheqlee/widget/profile/remove_.dart';

// Import your reusable button here
// import 'package:sheqlee/widget/common/app_primary_button.dart';
final skillDropdownOpenProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final levelDropdownOpenProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final selectedTagProvider = StateProvider.autoDispose<Tag?>((ref) => null);
final selectedLevelProvider = StateProvider.autoDispose<JobLevel?>(
  (ref) => null,
);

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // Local state for the loading indicator
  bool _isLoading = false;
  // ignore: non_constant_identifier_names
  final _Platform = TextEditingController();
  final _url = TextEditingController();
  int _parseLevel(String levelId) {
    // This looks at your "lvl_01", "lvl_02" etc and returns the number
    if (levelId.contains('01')) return 1;
    if (levelId.contains('02')) return 2;
    if (levelId.contains('03')) return 3;
    if (levelId.contains('04')) return 4;
    return 1; // Default
  }

  // --- CV Helper ---
  Future<void> _pickCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        ref.read(profileProvider.notifier).updateCV(result.files.first.name);
      }
    } catch (e) {
      debugPrint("Error picking CV: $e");
    }
  }

  // --- Profile Image Helper ---
  Future<void> _pickProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: true,
      );

      if (result != null && result.files.single.path != null) {
        ref
            .read(profileProvider.notifier)
            .updateProfileImage(result.files.single.path!);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // void _showProfilePopup() {
  //   String p = '';
  //   String u = '';
  //   _Platform.clear();
  // _url.clear();
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(

  //       title: Padding(
  //         padding: const EdgeInsets.only(left: 50.0),
  //         child: const Text(
  //           "Add a new profile",
  //           style: TextStyle(
  //             fontFamily: 'pretendard',
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextFormField(
  //             controller: _Platform,
  //             onChanged: (v) => p = v,
  //             decoration: InputDecoration(
  //               hintText: "Platform",
  //               hintStyle: TextStyle(
  //                 color: Color(0xffA0A0A0),
  //                 fontSize: 18,
  //                 fontFamily: 'pretendard',
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               contentPadding: const EdgeInsets.symmetric(
  //                 horizontal: 20,
  //                 vertical: 6,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 8),
  //           TextFormField(
  //             controller: _url,
  //             onChanged: (v) => u = v,
  //             decoration: InputDecoration(
  //               hintText: "URL",
  //               hintStyle: TextStyle(
  //                 color: Color(0xffA0A0A0),
  //                 fontSize: 18,
  //                 fontFamily: 'pretendard',
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               border: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               contentPadding: const EdgeInsets.symmetric(
  //                 horizontal: 20,
  //                 vertical: 6,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         Row(
  //           //crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             OutlinedButton(
  //               style: OutlinedButton.styleFrom(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(40),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 10,
  //                   horizontal: 20,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'cancel',
  //                 style: TextStyle(
  //                   fontFamily: 'pretendard',
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xff8967B3),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 15),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor:
  //                     (_Platform.text.trim().isNotEmpty &&
  //                         _url.text.trim().isNotEmpty)
  //                     ? Color(0xff8967B3)
  //                     : Color(0xff000000),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(40),
  //                 ),
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 10,
  //                   horizontal: 20,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 ref.read(profileProvider.notifier).addLink(p, u);
  //                 Navigator.pop(ctx);
  //               },
  //               child: const Text(
  //                 "Add profile",
  //                 style: TextStyle(
  //                   fontFamily: 'pretendard',
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xffFFFFFF),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _showProfilePopup() {
    // Reset controllers when opening
    _Platform.clear();
    _url.clear();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        // <--- 1. Wrap with StatefulBuilder
        builder: (context, setState) {
          // Calculate validity inside the builder
          final bool isFormValid =
              _Platform.text.trim().isNotEmpty && _url.text.trim().isNotEmpty;

          return AlertDialog(
            title: const Center(
              child: Text(
                "Add a new profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _Platform,
                  onChanged: (v) =>
                      setState(() {}), // <--- 2. Trigger rebuild on type
                  decoration: InputDecoration(
                    hintText: "Platform",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _url,
                  onChanged: (v) =>
                      setState(() {}), // <--- 2. Trigger rebuild on type
                  decoration: InputDecoration(
                    hintText: "URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 3. Conditional Color logic
                      backgroundColor: isFormValid
                          ? const Color(0xff8967B3)
                          : const Color(0xff000000),
                      disabledBackgroundColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    // 4. Disable action if invalid
                    onPressed: isFormValid
                        ? () {
                            ref
                                .read(profileProvider.notifier)
                                .addLink(
                                  _Platform.text.trim(),
                                  _url.text.trim(),
                                );
                            Navigator.pop(ctx);
                          }
                        : null,
                    child: const Text(
                      "Add profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final addedSkills = profile.skills;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              toolbarHeight: 120,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  double currentHeight = constraints.biggest.height;
                  double collapsePercent = ((120 - currentHeight) / 40).clamp(
                    0.0,
                    1.0,
                  );
                  double fontSize = 16 - (collapsePercent * 4);

                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    background: Container(color: Colors.white),
                    title: Stack(
                      children: [
                        Positioned(
                          top: 80,
                          left: 26,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBackButton(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainShellScreen(),
                                    ), // Replace 'HomePage' with your actual Home class name
                                    (route) => false,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- PROFILE IMAGE ---
                    Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickProfileImage,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    profile.profileImagePath != null
                                    ? FileImage(File(profile.profileImagePath!))
                                    : null,
                                child: profile.profileImagePath == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: GestureDetector(
                            //     onTap: _pickProfileImage,
                            //     child: const CircleAvatar(
                            //       radius: 14,
                            //       //backgroundColor: Color(0xff8967B3),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          onPressed: _pickProfileImage,
                          child: Text(
                            profile.profileImagePath == null
                                ? "Add photo"
                                : "change pic",
                            style: const TextStyle(
                              color: Color(0xff8967B3),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomProfileField(
                      label: "Full name",
                      hint: "Enter name",
                      initialValue: profile.fullName,
                      isRequired: true,
                      onChanged: (v) =>
                          ref.read(profileProvider.notifier).updateName(v),
                    ),
                    CustomProfileField(
                      label: "Title",
                      hint: "Professional headline",
                      isRequired: true,
                      onChanged: (v) =>
                          ref.read(profileProvider.notifier).updateTitle(v),
                    ),
                    CustomProfileField(
                      label: "Introduction",
                      hint: "Tell us about yourself",
                      maxLines: 4,
                      maxLength: 256,
                      onChanged: (v) =>
                          ref.read(profileProvider.notifier).updateIntro(v),
                    ),

                    // --- SKILLS ---
                    _buildDisplayField(
                      label: "Skills",
                      content: Column(
                        children: profile.skills
                            .map(
                              (skill) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      skill.tagName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    LevelIndicator(
                                      level: _parseLevel(skill.levelId),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (addedSkills.isNotEmpty)
                          ProfileActionButton(
                            label: "Remove skill",

                            onPressed: () => showRemoveSkillPopup(context, ref),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8967B3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => showSkillPopup(context, ref),
                          child: const Text(
                            "Add skill",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'pretendard',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- PROFILES
                    _buildDisplayField(
                      label: "Profiles",
                      content: Wrap(
                        runSpacing: 12,
                        children: profile.socialLinks.map((l) {
                          return InkWell(
                            onTap: () {
                              /* URL logic */
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Give the platform name a fixed width
                                // Adjust '91' here to represent the total space you want for the label
                                SizedBox(
                                  width: 140,
                                  child: Expanded(
                                    child: Text(
                                      l['platform']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'pretendard',
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),

                                // 2. The URL starts exactly after the 91px above
                                Expanded(
                                  child: Text(
                                    l['url']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff4285F4),
                                      fontFamily: 'pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (profile.socialLinks.isNotEmpty)
                          ProfileActionButton(
                            label: "Remove profile",
                            onPressed: () {},
                          ),
                        SizedBox(width: 5),
                        _buildAddButton("Add profile", _showProfilePopup),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // --- CV ---
                    _buildDisplayField(
                      label: "CV",
                      content: Text(
                        profile.cvFileName ?? "",
                        style: const TextStyle(
                          color: Color(0xff4A90E2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (profile.cvFileName != null)
                          ProfileActionButton(
                            label: "Download",
                            onPressed: () {},
                          ),
                        SizedBox(width: 5),
                        _buildAddButton(
                          (profile.cvFileName == null)
                              ? "Upload CV"
                              : "Change CV",
                          _pickCV,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // --- UPDATE BUTTON ROW ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppPrimaryButton(
                            text: "Update profile",
                            loading: _isLoading,
                            enabled: !_isLoading,
                            onPressed: () async {
                              setState(() => _isLoading = true);

                              final success = await ref
                                  .read(profileProvider.notifier)
                                  .uploadProfile();

                              if (mounted) setState(() => _isLoading = false);

                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Profile Updated!"),
                                  ),
                                );
                                Navigator.pop(context);
                              } else if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Upload failed. Try again."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayField({required String label, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff8967B3),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'pretendard',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
