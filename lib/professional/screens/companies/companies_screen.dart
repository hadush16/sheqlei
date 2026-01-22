import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/professional/screens/companies/companies_details_screen.dart';
import 'package:sheqlee/professional/widget/companies/company_card.dart';
import 'package:sheqlee/professional/widget/general_reusable/resizesable_sliver_appbar.dart';
import '../../providers/companies/companies_provider.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        // 'primary: true' lets the Scrollbar find this scroll view automatically
        primary: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          /// 🔙 Reusable Dynamic Header
          SliverPersistentHeader(
            pinned: true,
            delegate: DynamicSliverHeader(
              title: 'Companies',
              showSearch: false,
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
