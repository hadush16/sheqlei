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
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            _buildSection("", [widget.job.shortDescription]),

            _buildSection(
              "Qualifications",
              widget.job.details?.qualifications ?? [],
            ),
            _buildSection("Experience", widget.job.details?.experience ?? []),
            _buildSection(
              "Skills & Knowledge",
              widget.job.details?.skills ?? [],
            ),
            _buildSection("discription", widget.job.details?.discription ?? []),

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

  Widget _buildSection(String title, List<String> points) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title == "" ? point : "— $point",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
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
