import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/models/company_model.dart';
import 'package:sheqlee/providers/companies/company_jobs_provider.dart';
import 'package:sheqlee/providers/companies/subscription_provider.dart';
import 'package:sheqlee/widget/companies/company_logo.dart';
import 'package:sheqlee/widget/companies/company_widgets.dart';
import 'package:sheqlee/widget/home/empty_job_widget.dart';
import 'package:sheqlee/widget/home/job_card.dart';
import 'package:sheqlee/widget/login/backbutton.dart';

class CompanyDetailsScreen extends ConsumerWidget {
  final CompanyModel company;
  const CompanyDetailsScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(companyJobsProvider(company.id));
    final subscribedIds = ref.watch(companySubscriptionsProvider);
    final isSubscribed = subscribedIds.contains(company.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. PINNED HEADER (25px Left, 89px Top)
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 130,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 25, top: 89),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 80), // Centers "Details" text
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // 2. COMPANY PROFILE SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Company Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: getCompanyLogo(
                            company.id,
                          ), // Use the helper here
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Name & Verification
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  company.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (company.isVerified)
                                  const SizedBox(width: 5),
                                if (company.isVerified)
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.deepPurple,
                                    size: 16,
                                  ),
                              ],
                            ),
                            Text(
                              company.domain,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Subscription Bell
                      IconButton(
                        onPressed: () {
                          final notifier = ref.read(
                            companySubscriptionsProvider.notifier,
                          );
                          if (isSubscribed) {
                            notifier.state = {...subscribedIds}
                              ..remove(company.id);
                          } else {
                            notifier.state = {...subscribedIds}
                              ..add(company.id);
                          }
                        },
                        // FIX: The SvgPicture must be assigned to the 'icon' parameter
                        icon: SvgPicture.asset(
                          isSubscribed
                              ? 'assets/icons/bell-ring-solid.svg' // Ensure you have a filled version
                              : 'assets/icons/bell-ring-outline.svg',
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                            Color(0xffa06cd5),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Meta Data Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CompanyMetaTag(label: "${company.totalJobs} Jobs"),
                        const SizedBox(width: 8),
                        CompanyMetaTag(
                          label: "${company.totalSubscribers} Subs",
                        ),
                        const SizedBox(width: 8),
                        CompanyMetaTag(label: company.size),
                        const SizedBox(width: 8),
                        CompanyMetaTag(label: company.location),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description with "Read More" logic
                  // Inside CompanyDetailsScreen -> SliverToBoxAdapter -> Column
                  Text(
                    company.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () =>
                        _showAboutModal(context, company), // The trigger
                    child: const Text(
                      "Read more",
                      style: TextStyle(
                        color: Color(0xffa06cd5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 3. LIST OF JOBS BY COMPANY
          // 3. JOB LIST SECTION inside CompanyDetailsScreen
          jobsAsync.when(
            data: (jobs) {
              // Check if the company has created any jobs
              if (jobs.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    message: "This company hasn't posted\nany jobs yet.",
                    // You can hide the button by not passing onButtonPressed
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => JobCard(job: jobs[index]),
                    childCount: jobs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffa06cd5)),
              ),
            ),
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(child: Text("Error loading jobs: $err")),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutModal(BuildContext context, CompanyModel company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75, // Adjust height
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Close Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            // Title and Copy Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "About ${company.name}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // COPY BUTTON WITH SVG
                IconButton(
                  onPressed: () {
                    // Logic to copy text to clipboard
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/copy.svg', // Ensure you have this SVG
                    width: 22,
                    colorFilter: const ColorFilter.mode(
                      Color(0xffa06cd5),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Scrollable Full Description
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  company.description, // Ensure your model has this field
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
