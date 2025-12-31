import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/models/job_level_model.dart';
import 'package:sheqlee/models/job_type_model.dart';
import 'package:sheqlee/providers/jobs/tags_notifier.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/favotite_icon.dart';
import 'package:sheqlee/widget/job_metadata_section.dart';
import '../../models/job.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool isApplied = false;
  bool success = true; // example
  final ScrollController _scrollController = ScrollController();
  bool _showFavInHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // If user scrolls down more than 100 pixels, show fav in header
    if (_scrollController.offset > 100 && !_showFavInHeader) {
      setState(() => _showFavInHeader = true);
    } else if (_scrollController.offset <= 100 && _showFavInHeader) {
      setState(() => _showFavInHeader = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(BuildContext context, bool isApplied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApplied ? 'Applied successfully' : 'Application canceled',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: const Color(
          0xFF323232,
        ), // Dark grey/black like the image
        behavior: SnackBarBehavior.floating, // Makes it float
        width: 200, // Fixed width to make it compact
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTypes = ref.watch(jobTypesProvider).value ?? [];
    final allLevels = ref.watch(jobLevelsProvider).value ?? [];

    final String typeName = allTypes
        .firstWhere(
          (t) => t.id == widget.job.typeId,
          orElse: () => JobType(id: '', name: ''),
        )
        .name;

    final String levelName = allLevels
        .firstWhere(
          (l) => l.id == widget.job.levelId,
          orElse: () => JobLevel(id: '', name: ''),
        )
        .name;

    // 2. Filter out empty strings so we don't show empty boxes
    final List<String> topTags = [
      if (typeName.isNotEmpty) typeName,
      if (levelName.isNotEmpty) levelName,
      if (widget.job.salary.isNotEmpty) widget.job.salary,
    ];
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Stack(
                alignment:
                    Alignment.center, // Vertically centers items in the stack
                children: [
                  Positioned(left: 27, top: 26, child: AppBackButton()),

                  const Positioned(
                    left: 150,
                    right: 80,
                    top: 39,
                    child: Text(
                      "Job Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (_showFavInHeader)
                    Positioned(
                      right: 20,
                      child: FavoriteButton(jobId: widget.job.id),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, // Attach the controller here
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
                            job: widget.job, // Use widget.job here
                            showRocketIcon: false,
                          ),
                        ),
                        Opacity(
                          opacity: _showFavInHeader ? 0.0 : 1.0,
                          child: FavoriteButton(jobId: widget.job.id),
                        ), // Use widget.job here too
                      ],
                    ),
                    // Tags and Favorite Row
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Wrap(
                    //         spacing: 8,
                    //         children: widget.job.tags
                    //             .map((tag) => _buildTag(tag))
                    //             .toList(),
                    //       ),
                    //     ),
                    //     const Icon(Icons.favorite_border, color: Color(0xffa06cd5)),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    // Title and Company
                    Text(
                      widget.job.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.job.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.job.company,
                      style: const TextStyle(
                        color: Color(0xffa06cd5),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sections
                    // _buildSection("", [
                    //   widget.job.details?.location ?? "Location not specified",
                    // ]),
                    _buildSection("", widget.job.shortDescription), // Paragraph

                    _buildSection(
                      "Qualifications",
                      widget.job.details?.qualifications ?? "",
                    ), // Paragraph

                    _buildSection(
                      "Experience",
                      widget.job.details?.experience ?? "",
                    ), // Paragraph
                    // 👈 Pass List for Skills to enable bullet points
                    _buildSection(
                      "Skills & Knowledge",
                      widget.job.details?.skills ?? [],
                    ),

                    _buildSection(
                      "Description",
                      widget.job.details?.description ?? "",
                    ),
                    Row(children: [_buildTagsSection(ref)]),

                    const SizedBox(height: 30),

                    // Buttons Row (Inside the scrollview at the bottom)
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
                            onPressed: () {
                              // Handle Share
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xffa06cd5),
                                width: 2.4,
                              ),
                              iconSize: 20,
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
                    const SizedBox(height: 40), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
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
            const SizedBox(height: 12), // Increased space below title
          ],

          // 🎯 Multi-line Aligned Bullet Points (For Skills & Knowledge)
          if (content is List<String>)
            ...content.map(
              (point) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ), // Space between items
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align bullet to top of text
                  children: [
                    Text(
                      "—",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
          // 📝 Standard Paragraphs (For Experience, Description, etc.)
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

  // Inside your JobDetailsScreen build method or a dedicated widget
  Widget _buildTagsSection(WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);

    return tagsAsync.when(
      data: (tags) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        child: Wrap(
          spacing: 2.3,
          runSpacing: 5,
          children: [
            // The rocket icon tag shown in your image
            _buildIconTag(),
            // The dynamic list of tags
            ...tags.map((tag) => _buildTextTag(tag.name)).toList(),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(), // Or a small shimmer
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildIconTag() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: SvgPicture.asset('assets/icons/tag (1).svg', width: 19),
    );
  }

  Widget _buildTextTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xff000000)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xff303030),
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
