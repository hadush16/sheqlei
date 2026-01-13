import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/models/job.dart';
//import 'package:sheqlee/models/job_level_model.dart';
//import 'package:sheqlee/models/job_type_model.dart';
//import 'package:sheqlee/providers/jobs/level_type_notifier.dart';
import 'package:sheqlee/screens/home/job_details_screen.dart';
import 'package:sheqlee/widget/home/favotite_icon.dart';
import 'package:sheqlee/widget/home/job_metadata_section.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends ConsumerWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time
            Text(
              //job.timeAgo,
              timeago.format(job.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),

            // 2. Job Title
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'pretendard',
              ),
            ),
            const SizedBox(height: 2),

            // Company Name
            // Text(
            //   job.company,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Color(0xff8967B3),
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            const SizedBox(height: 8),

            // 3. Short Description
            // 3. Short Description (The snippet)
            // Text(
            //   job.shortDescription,
            //   //maxLines: ,
            //   overflow: TextOverflow.visible,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Color(0xff000000),
            //     fontFamily: 'pretendard',
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
            // Inside your JobCard build method
            Text(
              job.shortDescription, // Ensure this says shortDescription, NOT description
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'pretendard',
              ),
            ),
            const SizedBox(height: 12),

            // 4. Dynamic Tags + Favorite Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: JobMetadataSection(job: job, showRocketIcon: false),
                ),
                FavoriteButton(jobId: job.id),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xffE5E5E5)),
          ],
        ),
      ),
    );
  }
}
