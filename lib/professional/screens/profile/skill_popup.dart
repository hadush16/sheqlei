import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/professional/models/job_level_model.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/filter/filter_provider.dart';
import 'package:sheqlee/professional/providers/filter/level_type_dynamic_provider.dart';
import 'package:sheqlee/professional/providers/profile/edit_profile_provider.dart';
import 'package:sheqlee/professional/screens/profile/edit_profile.dart';
import 'package:sheqlee/professional/widget/profile/app_dropdown.dart';

// void showSkillPopup(BuildContext context, WidgetRef ref) {
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       backgroundColor: const Color(0xffF9F9F9),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       title: const Center(
//         child: Text(
//           "Add a new skill",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ),
//       content: Consumer(
//         builder: (context, ref, child) {
//           final selectedTag = ref.watch(selectedTagProvider);
//           final selectedLevel = ref.watch(selectedLevelProvider);
//           final isSkillOpen = ref.watch(skillDropdownOpenProvider);
//           final isLevelOpen = ref.watch(levelDropdownOpenProvider);
//           final levelsAsync = ref.watch(jobLevelsProvider);
//           final bool isFormValid = selectedTag != null && selectedLevel != null;

//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AppDropdown<Tag>(
//                 hint: "Skill",
//                 items: mockTags,
//                 value: selectedTag,
//                 isOpen: isSkillOpen,
//                 itemLabel: (tag) => tag.name,
//                 onTap: () =>
//                     ref.read(skillDropdownOpenProvider.notifier).state =
//                         !isSkillOpen,
//                 onChanged: (tag) {
//                   ref.read(skillDropdownOpenProvider.notifier).state = false;
//                   ref.read(selectedTagProvider.notifier).state = tag;
//                 },
//               ),
//               const SizedBox(height: 15),
//               levelsAsync.when(
//                 data: (levels) => AppDropdown<JobLevel>(
//                   hint: "Level",
//                   items: levels,
//                   value: selectedLevel,
//                   isOpen: isLevelOpen,
//                   itemLabel: (lvl) => lvl.name,
//                   onTap: () =>
//                       ref.read(levelDropdownOpenProvider.notifier).state =
//                           !isLevelOpen,
//                   onChanged: (lvl) {
//                     ref.read(levelDropdownOpenProvider.notifier).state = false;
//                     ref.read(selectedLevelProvider.notifier).state = lvl;
//                   },
//                 ),
//                 loading: () => const CircularProgressIndicator(),
//                 error: (err, _) => Text("Error: $err"),
//               ),
//             ],
//           );
//         },

//       ),
//       actions: [

//       ],
//     ),
//   );
// }
void showSkillPopup(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xffF9F9F9),
      // Use surfaceTintColor to prevent Material 3 from adding a purple overlay
      // surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // More rectangular
      title: const Center(
        child: Text(
          "Add a new skill",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      content: Consumer(
        builder: (context, ref, child) {
          final filterAsync = ref.watch(filterDataProvider);
          // 1. WATCH the providers here to trigger rebuilds on change
          final selectedTag = ref.watch(selectedTagProvider);
          final selectedLevel = ref.watch(selectedLevelProvider);
          final isSkillOpen = ref.watch(skillDropdownOpenProvider);
          final isLevelOpen = ref.watch(levelDropdownOpenProvider);
          //final levelsAsync = ref.watch(jobLevelsProvider);
          final levels = ref.watch(dynamicJobLevelsProvider);
          // 2. Define your condition
          final bool isFormValid = selectedTag != null && selectedLevel != null;

          return filterAsync.when(
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Text("Error loading skills: $err"),
            data: (data) => Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // Skill (Tag) Dropdown
                AppDropdown<Tag>(
                  hint: "Skill",
                  items: data.tags,
                  value: selectedTag,
                  isOpen: isSkillOpen,
                  itemLabel: (tag) => tag.name,
                  onTap: () =>
                      ref.read(skillDropdownOpenProvider.notifier).state =
                          !isSkillOpen,
                  onChanged: (tag) {
                    ref.read(skillDropdownOpenProvider.notifier).state = false;
                    ref.read(selectedTagProvider.notifier).state = tag;
                  },
                ),
                const SizedBox(height: 15),
                // FIX: Experience Level Dropdown (Using the dynamic list)
                AppDropdown<JobLevel>(
                  hint: "Level",
                  items: levels, // Using the list from ref.watch
                  value: selectedLevel,
                  isOpen: isLevelOpen,
                  itemLabel: (lvl) => lvl.name,
                  onTap: () =>
                      ref.read(levelDropdownOpenProvider.notifier).state =
                          !isLevelOpen,
                  onChanged: (lvl) {
                    ref.read(levelDropdownOpenProvider.notifier).state = false;
                    ref.read(selectedLevelProvider.notifier).state = lvl;
                  },
                ),
                const SizedBox(height: 24),

                // Move buttons inside Consumer so they react to selection
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xff8967B3)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2, // Makes the Add button longer
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // 3. APPLY CONDITIONAL COLOR
                          backgroundColor: isFormValid
                              ? const Color(0xff8967B3) // Purple when valid
                              : const Color(0xff000000), // Grey when invalid
                          //elevation: isFormValid ? 2 : 0,
                          disabledBackgroundColor: const Color(0xff000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: isFormValid
                            ? () {
                                ref
                                    .read(profileProvider.notifier)
                                    .addSkill(
                                      selectedTag.id,
                                      selectedTag.name,
                                      selectedLevel.id,
                                      selectedLevel.name,
                                    );
                                Navigator.pop(ctx);
                              }
                            : null, // Disable button if not valid
                        child: const Text(
                          "Add skill",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
