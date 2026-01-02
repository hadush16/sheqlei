// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sheqlee/models/skill_model.dart';
// import 'package:file_picker/file_picker.dart';

// class ProfileState {
//   final String fullName;
//   final String title;
//   final String introduction;
//   final List<SkillModel> skills;
//   final List<Map<String, String>> socialLinks;
//   final String? cvFileName; // New field for CV

//   ProfileState({
//     this.fullName = '',
//     this.title = '',
//     this.introduction = '',
//     this.skills = const [],
//     this.socialLinks = const [],
//     this.cvFileName,
//   });

//   ProfileState copyWith({
//     String? fullName,
//     String? title,
//     String? introduction,
//     List<SkillModel>? skills,
//     List<Map<String, String>>? socialLinks,
//     String? cvFileName,
//   }) => ProfileState(
//     fullName: fullName ?? this.fullName,
//     title: title ?? this.title,
//     introduction: introduction ?? this.introduction,
//     skills: skills ?? this.skills,
//     socialLinks: socialLinks ?? this.socialLinks,
//     cvFileName: cvFileName ?? this.cvFileName, // <--- AND THIS ONE
//     //cvFileName: cvFileName ?? this.cvFileName,
//   );
// }

// class ProfileNotifier extends StateNotifier<ProfileState> {
//   ProfileNotifier() : super(ProfileState(skills: <SkillModel>[]));

//   void updateName(String val) => state = state.copyWith(fullName: val);
//   void updateTitle(String val) => state = state.copyWith(title: val);
//   void updateIntro(String val) => state = state.copyWith(introduction: val);
//   // NEW: Method to update CV file name
//   void updateCV(String fileName) {
//     state = state.copyWith(cvFileName: fileName);
//   }

//   // NEW: Method to remove a skill by its ID
//   void removeSkill(String tagId) {
//     state = state.copyWith(
//       skills: state.skills.where((skill) => skill.tagId != tagId).toList(),
//     );
//   }

//   void addSkill(String tId, String tName, String lId, String lName) {
//     final skill = SkillModel(
//       tagId: tId,
//       tagName: tName,
//       levelId: lId,
//       levelName: lName,
//     );
//     state = state.copyWith(skills: [...state.skills, skill]);
//   }

//   void addLink(String platform, String url) {
//     state = state.copyWith(
//       socialLinks: [
//         ...state.socialLinks,
//         {"platform": platform, "url": url},
//       ],
//     );
//   }

//   Future<void> _handleCVUpload(WidgetRef ref) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx'],
//       );

//       if (result != null) {
//         // Get the file name from the result
//         String fileName = result.files.first.name;

//         // Update the Riverpod state
//         ref.read(profileProvider.notifier).updateCV(fileName);
//       }
//     } catch (e) {
//       debugPrint("Error picking file: $e");
//     }
//   }
// }

// final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
//   (ref) => ProfileNotifier(),
// );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/skill_model.dart';
import 'package:dio/dio.dart' as dio;

class ProfileState {
  final String fullName;
  final String title;
  final String introduction;
  final List<SkillModel> skills;
  final List<Map<String, String>> socialLinks;
  final String? cvFileName;
  final String? profileImagePath; // Store the local path of the picked image

  ProfileState({
    this.fullName = '',
    this.title = '',
    this.introduction = '',
    this.skills = const [],
    this.socialLinks = const [],
    this.cvFileName,
    this.profileImagePath,
  });

  ProfileState copyWith({
    String? fullName,
    String? title,
    String? introduction,
    List<SkillModel>? skills,
    List<Map<String, String>>? socialLinks,
    String? cvFileName,
    String? profileImagePath,
  }) => ProfileState(
    fullName: fullName ?? this.fullName,
    title: title ?? this.title,
    introduction: introduction ?? this.introduction,
    skills: skills ?? this.skills,
    socialLinks: socialLinks ?? this.socialLinks,
    cvFileName: cvFileName ?? this.cvFileName,
    profileImagePath: profileImagePath ?? this.profileImagePath,
  );
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  void updateName(String val) => state = state.copyWith(fullName: val);
  void updateTitle(String val) => state = state.copyWith(title: val);
  void updateIntro(String val) => state = state.copyWith(introduction: val);

  // Methods to update file states
  void updateCV(String fileName) =>
      state = state.copyWith(cvFileName: fileName);
  void updateProfileImage(String path) =>
      state = state.copyWith(profileImagePath: path);

  void addSkill(String tId, String tName, String lId, String lName) {
    final skill = SkillModel(
      tagId: tId,
      tagName: tName,
      levelId: lId,
      levelName: lName,
    );
    state = state.copyWith(skills: [...state.skills, skill]);
  }

  void removeSkill(String tagId) {
    state = state.copyWith(
      skills: state.skills.where((skill) => skill.tagId != tagId).toList(),
    );
  }

  void addLink(String platform, String url) {
    state = state.copyWith(
      socialLinks: [
        ...state.socialLinks,
        {"platform": platform, "url": url},
      ],
    );
  }

  Future<bool> uploadProfile() async {
    try {
      var formData = dio.FormData.fromMap({
        "full_name": state.fullName,
        "title": state.title,
        "introduction": state.introduction,
        // Using actual file paths for Multipart upload
        "cv": state.cvFileName != null && state.cvFileName != null
            ? await dio.MultipartFile.fromFile(
                state.cvFileName!,
                filename: state.cvFileName,
              )
            : null,
        "avatar": state.profileImagePath != null
            ? await dio.MultipartFile.fromFile(state.profileImagePath!)
            : null,
        // Convert skills list to JSON string or format required by your API
        "skills": state.skills.map((s) => s.toMap()).toList().toString(),
      });

      // Replace with your actual endpoint
      // await dio.Dio().post('https://your-api.com/profile', data: formData);

      print("Upload successful");
      return true;
    } catch (e) {
      print("Upload failed: $e");
      return false;
    }
  }

  // ... other methods (removeSkill, addLink)
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
