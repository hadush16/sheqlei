import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/providers/companies/subscription_provider.dart';
import '../../models/company_model.dart';
import 'package:sheqlee/widget/companies/company_widgets.dart';

class CompanyCard extends ConsumerWidget {
  final CompanyModel company;
  final VoidCallback onTap;

  const CompanyCard({super.key, required this.company, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribedIds = ref.watch(companySubscriptionsProvider);
    final isSubscribed = subscribedIds.contains(company.id);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    company.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                      fontFamily: 'pretendard',
                      fontSize: 20,
                    ),
                  ),
                ),
                if (company.isVerified)
                  SvgPicture.asset('assets/icons/verify-_1_.svg'),
              ],
            ),
            Text(
              company.domain,
              style: const TextStyle(
                color: Color(0xffa06cd5),
                fontFamily: 'pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              company.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff000000),
                fontFamily: 'pretendard',
                fontWeight: FontWeight.normal,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CompanyMetaTag(label: "${company.totalJobs} Jobs"),
                        const SizedBox(width: 8),
                        CompanyMetaTag(
                          label:
                              "${company.totalSubscribers + (isSubscribed ? 1 : 0)} Subs",
                        ), // Dynamic count
                        const SizedBox(width: 8),
                        CompanyMetaTag(label: company.size),
                        const SizedBox(width: 8),
                        CompanyMetaTag(label: company.location),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final notifier = ref.read(
                      companySubscriptionsProvider.notifier,
                    );
                    if (isSubscribed) {
                      notifier.state = {...notifier.state}..remove(company.id);
                    } else {
                      notifier.state = {...notifier.state}..add(company.id);
                    }
                  },
                  child: SvgPicture.asset(
                    // CHANGE ICON BASED ON STATE
                    isSubscribed
                        ? 'assets/icons/bell-ring-solid.svg' // Ensure you have a filled version
                        : 'assets/icons/bell-ring-outline.svg',

                    width: 20,

                    colorFilter: ColorFilter.mode(
                      const Color(0xffa06cd5),

                      isSubscribed ? BlendMode.srcIn : BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
