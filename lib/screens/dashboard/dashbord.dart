import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/dashboard/dashboard_provider.dart';
import 'package:sheqlee/screens/fitter/filter_page.dart';
import 'package:sheqlee/screens/profile/edit_profile.dart';
import 'package:sheqlee/widget/home/app_fab.dart';
import 'package:sheqlee/widget/home/app_sliver_header.dart';
import 'package:sheqlee/widget/home/empty_job_widget.dart';
import 'package:sheqlee/widget/home/job_card.dart'; // Ensure this exists

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch your MongoDB/Riverpod provider
    final filteredJobsAsync = ref.watch(filteredJobsProvider);
    return Scaffold(
      backgroundColor: Colors.white,

      // 2. FAB logic belongs HERE, outside the CustomScrollView
      floatingActionButton: filteredJobsAsync.maybeWhen(
        data: (jobs) => jobs.isNotEmpty
            ? AppFloatingActionButton(
                heroTag: "unique_dashboard_button",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterScreen()),
                ),
              )
            : null,
        orElse: () => null,
      ),

      body: CustomScrollView(
        slivers: [
          // 3. Header is a Sliver
          const AppSliverHeader(),

          // 4. Content must be Slivers
          filteredJobsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text("Error: $err"))),
            data: (jobs) {
              if (jobs.isEmpty) {
                // Wrap Box widgets in SliverFillRemaining
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmptyStateWidget(
                          message:
                              "Please add your\nskills to view a curated list",
                        ),
                        //const SizedBox(height: 24),
                        _buildEditButton(context),
                      ],
                    ),
                  ),
                );
              }

              // Return a SliverList for the data
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => JobCard(job: jobs[index]),
                  childCount: jobs.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff8967B3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        ),
        child: const Text(
          'Edit profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
