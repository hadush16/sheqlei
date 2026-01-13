import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/screens/companies/companies_details_screen.dart';
import 'package:sheqlee/widget/companies/company_card.dart';
import 'package:sheqlee/widget/login/backbutton.dart';
import '../../providers/companies/companies_provider.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // DESIGN: Fixed at top, 25px Left, 89px Top
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 130, // Tall enough to handle the 89px offset
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 25, top: 89),
              child: Row(
                children: [
                  const AppBackButton(), // Your reusable button with the SVG
                  const SizedBox(width: 15),
                  const Text(
                    'Companies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'pretendard',
                    ),
                  ),
                ],
              ),
            ),
          ),

          companiesAsync.when(
            data: (companies) {
              if (companies.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/sad.svg',
                          width: 120,
                        ), // EMPTY SVG
                        const SizedBox(height: 10),
                        const Text(
                          "No Companies Available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CompanyCard(
                    company: companies[index],
                    onTap: () {
                      // Navigate to the Details Screen and pass the company data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanyDetailsScreen(company: companies[index]),
                        ),
                      );
                    },
                  ),
                  childCount: companies.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xffa06cd5)),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: $err", textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => ref.refresh(companiesProvider),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
