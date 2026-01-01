// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sheqlee/providers/jobs/tags_notifier.dart';
// import 'package:sheqlee/widget/backbutton.dart';
// import 'package:sheqlee/widget/favotite_icon.dart';
// import 'package:sheqlee/widget/job_metadata_section.dart';
// import '../../models/job.dart';

// class JobDetailsScreen extends ConsumerStatefulWidget {
//   final Job job;
//   const JobDetailsScreen({super.key, required this.job});

//   @override
//   ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
// }

// class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
//   bool isApplied = false;
//   bool success = true; // example
//   final ScrollController _scrollController = ScrollController();
//   bool _showFavInHeader = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     // If user scrolls down more than 100 pixels, show fav in header
//     if (_scrollController.offset > 80 && !_showFavInHeader) {
//       setState(() => _showFavInHeader = true);
//     } else if (_scrollController.offset <= 80 && _showFavInHeader) {
//       setState(() => _showFavInHeader = false);
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _showCustomSnackBar(BuildContext context, bool isApplied) {
//     ScaffoldMessenger.of(
//       context,
//     ).hideCurrentSnackBar(); // Clears any existing snackbar first

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           isApplied ? 'Applied successfully' : 'Application canceled',
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//         ),
//         backgroundColor: const Color(0xFF323232),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

//         margin: EdgeInsets.only(
//           bottom: 70,
//           left: MediaQuery.of(context).size.width * 0.25,
//           right: MediaQuery.of(context).size.width * 0.19,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 89,
//               width: double.infinity,
//               child: Stack(
//                 alignment:
//                     Alignment.center, // Vertically centers items in the stack
//                 children: [
//                   Positioned(left: 27, top: 40, child: AppBackButton()),

//                   const Positioned(
//                     left: 150,
//                     right: 80,
//                     top: 49,
//                     child: Text(
//                       "Job Details",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'pretendard',
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   if (_showFavInHeader)
//                     Positioned(
//                       right: 20,
//                       top: 49,
//                       child: FavoriteButton(jobId: widget.job.id),
//                     ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 controller: _scrollController, // Attach the controller here
//                 padding: const EdgeInsets.symmetric(horizontal: 21),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: JobMetadataSection(
//                             job: widget.job, // Use widget.job here
//                             showRocketIcon: false,
//                           ),
//                         ),
//                         Opacity(
//                           opacity: _showFavInHeader ? 0.0 : 1.0,
//                           child: FavoriteButton(jobId: widget.job.id),
//                         ), // Use widget.job here too
//                       ],
//                     ),

//                     const SizedBox(height: 20),
//                     // Title and Company
//                     Text(
//                       widget.job.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'pretendard',
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                     Text(
//                       widget.job.time,
//                       style: const TextStyle(
//                         color: Color(0xff909090),
//                         fontSize: 10,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.job.company,
//                       style: const TextStyle(
//                         color: Color(0xffa06cd5),
//                         //decoration: TextDecoration.underline,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 23),
//                     // Sections
//                     // _buildSection("", [
//                     //   widget.job.details?.location ?? "Location not specified",
//                     // ]),
//                     _buildSection("", widget.job.shortDescription), // Paragraph

//                     _buildSection(
//                       "Qualifications",
//                       widget.job.details?.qualifications ?? "",
//                     ), // Paragraph

//                     _buildSection(
//                       "Experience",
//                       widget.job.details?.experience ?? "",
//                     ), // Paragraph
//                     // 👈 Pass List for Skills to enable bullet points
//                     _buildSection(
//                       "Skills & Knowledge",
//                       widget.job.details?.skills ?? [],
//                     ),

//                     _buildSection(
//                       "Description",
//                       widget.job.details?.description ?? "",
//                     ),
//                     Row(children: [_buildTagsSection(ref)]),

//                     const SizedBox(height: 30),

//                     // Buttons Row (Inside the scrollview at the bottom)
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 isApplied = !isApplied;

//                                 _showCustomSnackBar(context, isApplied);
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: isApplied
//                                   ? Colors.red
//                                   : const Color(0xffa06cd5),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: Text(
//                               isApplied ? "Cancel Application" : "Apply",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           flex: 1,
//                           child: OutlinedButton(
//                             onPressed: () {
//                               // Handle Share
//                             },
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               side: const BorderSide(
//                                 color: Color(0xffa06cd5),
//                                 width: 2.4,
//                               ),
//                               iconSize: 20,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: const Text(
//                               "Share",
//                               style: TextStyle(
//                                 color: Color(0xffa06cd5),
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40), // Bottom padding
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, dynamic content) {
//     if (content == null ||
//         (content is String && content.isEmpty) ||
//         (content is List && content.isEmpty)) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (title.isNotEmpty) ...[
//             Text(
//               title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12), // Increased space below title
//           ],

//           // 🎯 Multi-line Aligned Bullet Points (For Skills & Knowledge)
//           if (content is List<String>)
//             ...content.map(
//               (point) => Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: 8,
//                 ), // Space between items
//                 child: Row(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start, // Align bullet to top of text
//                   children: [
//                     Text(
//                       "— ",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'pretendard',
//                         fontSize: 14,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         point,
//                         style: TextStyle(
//                           color: Colors.black.withOpacity(0.7),
//                           height: 1.5,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           // 📝 Standard Paragraphs (For Experience, Description, etc.)
//           else if (content is String)
//             Text(
//               content,
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.7),
//                 height: 1.6,
//                 fontSize: 14,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // Inside your JobDetailsScreen build method or a dedicated widget
//   Widget _buildTagsSection(WidgetRef ref) {
//     final tagsAsync = ref.watch(tagsProvider);

//     return tagsAsync.when(
//       data: (tags) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
//         child: Wrap(
//           spacing: 2.3,
//           runSpacing: 5,
//           children: [
//             // The rocket icon tag shown in your image
//             _buildIconTag(),
//             // The dynamic list of tags
//             ...tags.map((tag) => _buildTextTag(tag.name)).toList(),
//           ],
//         ),
//       ),
//       loading: () => const SizedBox.shrink(), // Or a small shimmer
//       error: (_, __) => const SizedBox.shrink(),
//     );
//   }

//   Widget _buildIconTag() {
//     return Container(
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//       child: SvgPicture.asset('assets/icons/tag (1).svg', width: 19),
//     );
//   }

//   Widget _buildTextTag(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Color(0xff000000)),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(
//           fontSize: 12,
//           color: Color(0xff303030),
//           fontWeight: FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/providers/jobs/tags_notifier.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/favotite_icon.dart';
import 'package:sheqlee/widget/job_metadata_section.dart';
import '../../models/job.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool isApplied = false;
  final ScrollController _scrollController = ScrollController();
  bool _showFavInHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 80 && !_showFavInHeader) {
      setState(() => _showFavInHeader = true);
    } else if (_scrollController.offset <= 80 && _showFavInHeader) {
      setState(() => _showFavInHeader = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(BuildContext context, bool isApplied) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApplied ? 'Applied successfully' : 'Application canceled',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: const Color(0xFF323232),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(
          bottom: 70,
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.19,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: 89,
                collapsedHeight: 60,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                // We use flexibleSpace but put our items in a Stack
                // OUTSIDE of the background property so they don't fade.
                flexibleSpace: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back Button - Always Visible
                    Positioned(
                      left: 27,
                      bottom: 12, // Adjusted for collapsed view
                      child: AppBackButton(),
                    ),

                    // Title - Always Visible
                    Positioned(
                      bottom: 18,
                      child: Text(
                        "Job Details",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'pretendard',
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Favorite Button - Shows based on your existing scroll logic
                    if (_showFavInHeader)
                      Positioned(
                        right: 20,
                        bottom: 10,
                        child: FavoriteButton(jobId: widget.job.id),
                      ),
                  ],
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: JobMetadataSection(
                        job: widget.job,
                        showRocketIcon: false,
                      ),
                    ),
                    Opacity(
                      opacity: _showFavInHeader ? 0.0 : 1.0,
                      child: FavoriteButton(jobId: widget.job.id),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.job.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'pretendard',
                    color: Color(0xff000000),
                  ),
                ),
                Text(
                  widget.job.time,
                  style: const TextStyle(
                    color: Color(0xff909090),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.job.company,
                  style: const TextStyle(
                    color: Color(0xffa06cd5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 23),
                _buildSection("", widget.job.shortDescription),
                _buildSection(
                  "Qualifications",
                  widget.job.details?.qualifications ?? "",
                ),
                _buildSection(
                  "Experience",
                  widget.job.details?.experience ?? "",
                ),
                _buildSection(
                  "Skills & Knowledge",
                  widget.job.details?.skills ?? [],
                ),
                _buildSection(
                  "Description",
                  widget.job.details?.description ?? "",
                ),
                _buildTagsSection(ref),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isApplied = !isApplied;
                            _showCustomSnackBar(context, isApplied);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApplied
                              ? Colors.red
                              : const Color(0xffa06cd5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          isApplied ? "Cancel Application" : "Apply",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xffa06cd5),
                            width: 2.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Share",
                          style: TextStyle(
                            color: Color(0xffa06cd5),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    if (content == null ||
        (content is String && content.isEmpty) ||
        (content is List && content.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          if (content is List<String>)
            ...content.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("— ", style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (content is String)
            Text(
              content,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                height: 1.6,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);
    return tagsAsync.when(
      data: (tags) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Wrap(
          spacing: 2.3,
          runSpacing: 5,
          children: [
            _buildIconTag(),
            ...tags.map((tag) => _buildTextTag(tag.name)).toList(),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildIconTag() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset('assets/icons/tag (1).svg', width: 19),
    );
  }

  Widget _buildTextTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff000000)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Color(0xff303030)),
      ),
    );
  }
}
