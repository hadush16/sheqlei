import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sheqlee/professional/providers/tags/tag_search_provider.dart';
import 'package:sheqlee/professional/screens/tags/tags_details.dart';
import 'package:sheqlee/professional/widget/login/backbutton.dart'; // Ensure correct import

class TagSearchScreen extends ConsumerWidget {
  const TagSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(searchSuggestionsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. REUSABLE HEADER LOGIC
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchHeaderDelegate(ref: ref),
          ),

          // 2. SEARCH RESULTS
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final tag = suggestions[index];
                return ListTile(
                  title: Text(
                    tag.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'pretendard',
                    ),
                  ),
                  subtitle: Text(
                    "${tag.totalJobs} Jobs",
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'pretendard',
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagDetailScreen(tag: tag),
                      ),
                    );
                  },
                );
              }, childCount: suggestions.length),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final WidgetRef ref;
  SearchHeaderDelegate({required this.ref});

  // 82 (top padding) + 40 (container height) = 122
  // We use 122 to ensure the layoutExtent and paintExtent match perfectly
  @override
  double get maxExtent => 122.0;

  @override
  double get minExtent => 122.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
        child: Padding(
          // Top is exactly 82, horizontal is 25 to match your DynamicSliverHeader
          padding: const EdgeInsets.only(top: 89, right: 25),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align with the top of the 82px mark
            children: [
              // 1. Back Button
              Transform.translate(
                offset: const Offset(
                  21,
                  0,
                ), // Nudges the button 8 pixels to the right
                child: const AppBackButton(),
              ),

              // 2. Search Field Box
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Color(0xff000000)),
                  ),
                  child: TextField(
                    autofocus: false,
                    onChanged: (val) =>
                        ref.read(tagSearchQueryProvider.notifier).state = val,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: "Search",
                      prefixIconConstraints: const BoxConstraints(minWidth: 15),

                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7.0,
                          vertical: 8,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/search-alt2 (3) copy.svg',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(
                        fontFamily: 'pretendard',
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 3. Cancel Button
              GestureDetector(
                onTap: () {
                  ref.read(tagSearchQueryProvider.notifier).state = "";
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ), // Centers text vertically with the 40px box
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'pretendard',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
