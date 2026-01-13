import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/models/tag_model.dart';
import 'package:sheqlee/providers/bottomnavigation/navigation_provider.dart';
import 'package:sheqlee/providers/profile/edit_profile_provider.dart';
//import 'package:sheqlee/screens/home/home_page.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/screens/profile/skill_popup.dart';
import 'package:sheqlee/widget/login/app_primary_button.dart';
import 'package:sheqlee/widget/login/backbutton.dart';
import 'package:sheqlee/widget/profile/actionbutton.dart';
import 'package:sheqlee/widget/profile/custom_scrollable_field.dart';
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
  // --- ADD THIS METHOD HERE ---
  int _getInternalLevelValue(String? levelId) {
    if (levelId == null) return 0;
    final l = levelId.toLowerCase();
    if (l.contains('begin') || l.contains('junior')) return 1;
    if (l.contains('inter')) return 2;
    if (l.contains('seni')) return 3;
    if (l.contains('expert')) return 4;
    return 0;
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
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _Platform,
                    onChanged: (v) =>
                        setState(() {}), // <--- 2. Trigger rebuild on type
                    decoration: InputDecoration(
                      hintText: "Platform",
                      isDense: true, // 1. Reduces height significantly
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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
                      isDense: true, // 1. Reduces height significantly
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
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
    bool isFormValid() {
      // 1. Check basic text fields
      final isNameValid = profile.fullName.trim().isNotEmpty;
      final isTitleValid = profile.title.trim().isNotEmpty;

      // 2. Check lists (Skills and Profiles)
      final hasSkills = profile.skills.isNotEmpty;
      // final hasSocials = profile.socialLinks.isNotEmpty;

      // 3. Check CV (Check if a file name or path exists)
      final hasCV =
          profile.cvFileName != null && profile.cvFileName!.isNotEmpty;

      return isNameValid && isTitleValid && hasSkills && hasCV;
    }

    final bool canUpdate = isFormValid();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        body: Stack(
          children: [
            CustomScrollView(
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
                      double collapsePercent = ((120 - currentHeight) / 40)
                          .clamp(0.0, 1.0);
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
                                        ? FileImage(
                                            File(profile.profileImagePath!),
                                          )
                                        : null,
                                    child: profile.profileImagePath == null
                                        ? SvgPicture.asset(
                                            'assets/icons/settings - alt2 (1).svg',
                                            width:
                                                30, // Adjust size to fit inside circle
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                  ),
                                ),
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
                          hint: "Self introduction",
                          maxLines: 4,
                          maxLength: 256,
                          onChanged: (v) =>
                              ref.read(profileProvider.notifier).updateIntro(v),
                        ),

                        // --- SKILLS ---
                        CustomScrollableField(
                          itemCount: profile.skills.length,
                          label: "Skills",
                          content: Column(
                            children: profile.skills.map((skill) {
                              // Convert the string level (e.g., "Intermediate") to a number (e.g., 2)
                              int levelNumber = _getInternalLevelValue(
                                skill.levelName,
                              );

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      skill.tagName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    // Your custom indicator widget
                                    LevelIndicator(level: levelNumber),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (addedSkills.isNotEmpty)
                              ProfileActionButton(
                                label: "Remove skill",

                                onPressed: () {
                                  showGenericActionPopup(
                                    context: context,
                                    title: "Remove a skill",
                                    //: SvgPicture.asset('assets/icons/delete - alt2.svg'),
                                    itemsSelector: (state) =>
                                        state.skills, // This makes it reactive
                                    labelBuilder: (skill) => skill.tagName,
                                    onActionPressed: (ref, skill) {
                                      ref
                                          .read(profileProvider.notifier)
                                          .removeSkill(skill);
                                    },
                                  );
                                },
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
                        CustomScrollableField(
                          itemCount: profile.socialLinks.length,
                          label: "Profiles",
                          content: Wrap(
                            runSpacing: 12,
                            children: profile.socialLinks.map((l) {
                              return InkWell(
                                onTap: () {
                                  /* URL logic */
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ), // Better tap target
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 1. Give the platform name a fixed width
                                      // Adjust '91' here to represent the total space you want for the label
                                      SizedBox(
                                        width: 90,
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
                                        //),
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
                                onPressed: () {
                                  showGenericActionPopup(
                                    context: context,
                                    // 1. Selector points to your list of maps in ProfileState
                                    itemsSelector: (state) => state.socialLinks,
                                    title: "Remove profile",

                                    // 2. Access the 'platform' key from the Map
                                    labelBuilder: (link) =>
                                        link['platform'] ?? 'Unknown',

                                    // 3. Logic to remove by the specific platform name
                                    onActionPressed: (ref, link) {
                                      final platformName = link['platform'];
                                      if (platformName != null) {
                                        ref
                                            .read(profileProvider.notifier)
                                            .removeLink(platformName);
                                      }
                                    },
                                  );
                                },
                              ),
                            SizedBox(width: 5),
                            _buildAddButton("Add profile", _showProfilePopup),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // --- CV ---
                        CustomScrollableField(
                          itemCount: profile.cvList.length,
                          label: Text.rich(
                            TextSpan(
                              text: "CV ",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ), // Same as your other labels
                              children: [
                                TextSpan(
                                  text: "*",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ), // Red Star
                                ),
                              ],
                            ),
                          ),
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
                                onPressed: () {
                                  showGenericActionPopup(
                                    context: context,
                                    title: "Download CV",
                                    // 1. Wrap the single filename in a List [ ] so the popup can iterate over it
                                    itemsSelector: (state) =>
                                        state.cvFileName != null
                                        ? [state.cvFileName!]
                                        : [],

                                    // 2. Since the item is just a String, the label is the item itself
                                    labelBuilder: (fileName) => fileName,
                                    // 🟢 ADD THIS LINE TO CHANGE THE ICON FOR THIS SPECIFIC POPUP
                                    // actionIconPath: 'assets/iconsimage.png',

                                    /// actionIcon: Icons.download,
                                    actionColor: Color(0xff8967B3),
                                    onActionPressed: (ref, fileName) {
                                      // Implement your download/open logic here
                                      print("Downloading $fileName");
                                    },
                                  );
                                },
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

                        const SizedBox(height: 80),

                        // --- UPDATE BUTTON ROW ---
                        //const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // 3. The Fixed Button
            Positioned(
              //top: 100,
              left: 25,
              right: 25,
              bottom: 10, // Your specific height from bottom
              child: AppPrimaryButton(
                text: "Update profile",
                enabled: canUpdate,
                loading: _isLoading,
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    final success = await ref
                        .read(profileProvider.notifier)
                        .saveProfile();

                    if (success && mounted) {
                      ref.read(navigationIndexProvider.notifier).state = 0;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainShellScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    debugPrint("Save failed: $e");
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDisplayField({required dynamic label, required Widget content}) {
  //   final ScrollController internalController = ScrollController();
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5),
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.grey.shade400),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           label is String
  //               ? Text(
  //                   label,
  //                   style: const TextStyle(color: Colors.grey, fontSize: 18),
  //                 )
  //               : label,
  //           const SizedBox(height: 8),
  //           // --- SCROLLABLE AREA START ---
  //           ConstrainedBox(
  //             constraints: const BoxConstraints(
  //               // Adjust maxHeight based on the height of roughly 2 items
  //               maxHeight: 60,
  //             ),

  //             child: RawScrollbar(
  //               controller: internalController,
  //               thumbVisibility: true,
  //               thickness: 4,
  //               thumbColor: Colors.black, // Your black scroll icon
  //               radius: const Radius.circular(10),

  //               child: SingleChildScrollView(
  //                 controller:
  //                     internalController, // MUST match the Scrollbar controller
  //                 physics:
  //                     const AlwaysScrollableScrollPhysics(), // Ensures it scrolls even with few items
  //                 child: Padding(
  //                   // Extra right padding so content doesn't sit under the scrollbar
  //                   padding: const EdgeInsets.only(right: 16),
  //                   child: content,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           //
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
