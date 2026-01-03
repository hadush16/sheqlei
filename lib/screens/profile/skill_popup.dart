import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/data/mock_data.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart';
import 'package:sheqlee/providers/profile/edit_profile_provider.dart';
import 'package:sheqlee/screens/profile/edit_profile.dart';
import 'package:sheqlee/widget/profile/app_dropdown.dart';

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
          // 1. WATCH the providers here to trigger rebuilds on change
          final selectedTag = ref.watch(selectedTagProvider);
          final selectedLevel = ref.watch(selectedLevelProvider);
          final isSkillOpen = ref.watch(skillDropdownOpenProvider);
          final isLevelOpen = ref.watch(levelDropdownOpenProvider);
          final levelsAsync = ref.watch(jobLevelsProvider);

          // 2. Define your condition
          final bool isFormValid = selectedTag != null && selectedLevel != null;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDropdown<Tag>(
                hint: "Skill",
                items: mockTags,
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
              levelsAsync.when(
                data: (levels) => AppDropdown<JobLevel>(
                  hint: "Level",
                  items: levels,
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
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text("Error: $err"),
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
          );
        },
      ),
    ),
  );
}
