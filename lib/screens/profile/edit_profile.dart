import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart';
import 'package:sheqlee/providers/profile/edit_profile_provider.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/editable_text_form.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});
  void _handleCVUpload(WidgetRef ref) {
    // Logic to pick file goes here
    // For now, we mock the result:
    //ref.read(profileProvider.notifier).updateCV("");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Back Button and Title in one row
          // SliverAppBar(
          //   pinned: true,
          //   expandedHeight: 200,
          //   backgroundColor: Colors.white,
          //   leading: const Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: CircleAvatar(
          //       backgroundColor: Colors.black12,
          //       child: BackButton(color: Colors.black),
          //     ),
          //   ),
          //   centerTitle: true,
          //   title: const Text(
          //     "Edit Profile",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   flexibleSpace: FlexibleSpaceBar(
          //     background: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const SizedBox(height: 50),
          //         CircleAvatar(
          //           radius: 45,
          //           backgroundColor: Colors.grey.shade100,
          //           // Check if we have a path in our profile state
          //           backgroundImage: profile.profileImagePath != null
          //               ? FileImage(File(profile.profileImagePath!))
          //               : null,
          //           child: profile.profileImagePath == null
          //               ? const Icon(Icons.person, size: 40, color: Colors.grey)
          //               : null,
          //         ),
          //         TextButton(
          //           onPressed: () =>
          //               pickProfileImage(ref), // Call the helper here
          //           child: Text("Add a photo"),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: Colors.white,
            elevation: 0,
            //toolbarHeight: 90,
            leading: Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 40),
              child: const AppBackButton(),
            ),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: const Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Calculate how much the bar has collapsed
                // 0.0 = fully expanded, 1.0 = fully collapsed
                double top = constraints.biggest.height;
                double collapsePercent = ((250 - top) / (250 - 90)).clamp(
                  0.0,
                  1.0,
                );
                double opacity =
                    1.0 - collapsePercent; // Fades out as you scroll up

                return FlexibleSpaceBar(
                  background: Opacity(
                    opacity: opacity, // Smoothly fades the row out
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, top: 120),
                      child: Transform.scale(
                        scale: 1.0 - (collapsePercent * 0.7), // Shrinks by 20%
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- PROFILE IMAGE ---
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage:
                                      profile.profileImagePath != null
                                      ? FileImage(
                                          File(profile.profileImagePath!),
                                        )
                                      : null,
                                  child: profile.profileImagePath == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => pickProfileImage(ref),
                                    child: const CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Color(0xff8967B3),
                                      child: Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            // --- ADD PHOTO BUTTON ---
                            TextButton(
                              onPressed: () => pickProfileImage(ref),
                              child: const Text(
                                "Add photo",
                                style: TextStyle(
                                  color: Color(0xff8967B3),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 2. Scrollable Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Inside your EditProfilePage build method:

                  // --- SKILLS FIELD ---
                  _buildDisplayField(
                    label: "Skills *",
                    content: profile.skills.isEmpty
                        ? const Text(
                            "No skills added",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            children: profile.skills
                                .map(
                                  (s) => Chip(
                                    label: Text(
                                      "${s.tagName} (${s.levelName})",
                                    ),
                                    onDeleted: () => ref
                                        .read(profileProvider.notifier)
                                        .removeSkill(s.tagId),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  _buildAddButton(
                    "Add skill",
                    () => _showSkillPopup(context, ref),
                  ),

                  const SizedBox(height: 10),

                  // --- PROFILES FIELD ---
                  _buildDisplayField(
                    label: "Profiles",
                    content: profile.socialLinks.isEmpty
                        ? const Text(
                            "No social links added",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Column(
                            children: profile.socialLinks
                                .map(
                                  (l) => ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.link, size: 18),
                                    title: Text(
                                      l['platform']!,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    subtitle: Text(
                                      l['url']!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  _buildAddButton(
                    "Add profile",
                    () => _showProfilePopup(context, ref),
                  ),

                  const SizedBox(height: 10),

                  // --- CV FIELD ---
                  _buildDisplayField(
                    label: "CV *",
                    content: Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: profile.cvFileName == null
                              ? Colors.grey
                              : Colors.redAccent,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            profile.cvFileName ?? "No CV uploaded",
                            style: TextStyle(
                              color: profile.cvFileName == null
                                  ? Colors.grey
                                  : Colors.black,
                              fontWeight: profile.cvFileName == null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CHANGE: Call pickCV(ref) here
                  _buildAddButton("Upload CV", () async => await pickCV(ref)),
                  const SizedBox(height: 40),

                  // 3. Update Button - Now inside the scroll view
                  // ElevatedButton(
                  //   onPressed: () => print("Update Clicked"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.black,
                  //     minimumSize: const Size(double.infinity, 55),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     "Update profile",
                  //     style: TextStyle(color: Colors.white, fontSize: 16),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      // 1. Trigger the upload from the notifier
                      final success = await ref
                          .read(profileProvider.notifier)
                          .uploadProfile();

                      if (success) {
                        // 2. Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile Updated!")),
                        );

                        // 3. Navigate back to Home
                        // Use pop() to go back to the previous screen in the stack
                        Navigator.pop(context);

                        // OR if you want to explicitly go to a Home route:
                        // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Upload failed. Try again."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Update profile",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
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
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 18, color: Color(0xff8967B3)),
        label: Text(label, style: const TextStyle(color: Color(0xff8967B3))),
      ),
    );
  }

  // Popup for Skills using Tag/Level IDs
  void _showSkillPopup(BuildContext context, WidgetRef ref) {
    // Local variables to store selection
    String? selectedTagId;
    String? selectedTagName;
    String? selectedLevelId;
    String? selectedLevelName;

    // Watch the levels provider (FutureProvider)
    final levelsAsync = ref.watch(jobLevelsProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Add New Skill",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Skill Selection (from mockTags)
            DropdownButtonFormField<Tag>(
              decoration: const InputDecoration(
                labelText: "Select Skill",
                border: OutlineInputBorder(),
              ),
              items: mockTags
                  .map(
                    (tag) =>
                        DropdownMenuItem(value: tag, child: Text(tag.name)),
                  )
                  .toList(),
              onChanged: (tag) {
                selectedTagId = tag?.id;
                selectedTagName = tag?.name;
              },
            ),
            const SizedBox(height: 16),

            // 2. Level Selection (Handling FutureProvider state)
            levelsAsync.when(
              data: (levels) => DropdownButtonFormField<JobLevel>(
                decoration: const InputDecoration(
                  labelText: "Proficiency Level",
                  border: OutlineInputBorder(),
                ),
                items: levels
                    .map(
                      (lvl) =>
                          DropdownMenuItem(value: lvl, child: Text(lvl.name)),
                    )
                    .toList(),
                onChanged: (lvl) {
                  selectedLevelId = lvl?.id;
                  selectedLevelName = lvl?.name;
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text("Error loading levels: $err"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (selectedTagId != null && selectedLevelId != null) {
                // EFFECTIVE ADD: Save to the Profile Provider
                ref
                    .read(profileProvider.notifier)
                    .addSkill(
                      selectedTagId!,
                      selectedTagName!,
                      selectedLevelId!,
                      selectedLevelName!,
                    );
                Navigator.pop(ctx);
              } else {
                // Optional: Show a snackbar if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select both skill and level"),
                  ),
                );
              }
            },
            child: const Text(
              "Add Skill",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfilePopup(BuildContext context, WidgetRef ref) {
    String p = '';
    String u = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (v) => p = v,
              decoration: const InputDecoration(hintText: "Platform"),
            ),
            TextField(
              onChanged: (v) => u = v,
              decoration: const InputDecoration(hintText: "URL"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(profileProvider.notifier).addLink(p, u);
              Navigator.pop(ctx);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Helper for CV
  Future<void> pickCV(WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
        ], // Added docx for better compatibility
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        // Update the provider state with the file name
        ref.read(profileProvider.notifier).updateCV(result.files.first.name);
        print("File picked: ${result.files.first.name}");
      } else {
        // User canceled the picker
        print("User canceled file picking");
      }
    } catch (e) {
      print("Error picking CV: $e");
    }
  }

  // Helper for Profile Image
  Future<void> pickProfileImage(WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Ensure this is set to image
        allowCompression: true,
      );

      if (result != null && result.files.single.path != null) {
        // We save the path (String) to the provider
        ref
            .read(profileProvider.notifier)
            .updateProfileImage(result.files.single.path!);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }
}
