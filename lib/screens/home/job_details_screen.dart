import 'package:flutter/material.dart';
import '../../models/job.dart'; // Adjust path to your model

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isApplied = false;
  bool success = true; // example
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Tags and Favorite Row
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: widget.job.tags
                        .map((tag) => _buildTag(tag))
                        .toList(),
                  ),
                ),
                const Icon(Icons.favorite_border, color: Color(0xffa06cd5)),
              ],
            ),
            const SizedBox(height: 20),
            // Title and Company
            Text(
              widget.job.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

            _buildSection("Description", widget.job.details?.description ?? ""),

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
                      side: const BorderSide(color: Color(0xffa06cd5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Share",
                      style: TextStyle(color: Color(0xffa06cd5), fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // Bottom padding
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

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
