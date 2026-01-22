import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/models/tag_model.dart';
import 'package:sheqlee/professional/providers/tags/tags_provider.dart';
import 'package:sheqlee/professional/screens/tags/tags_details.dart';
import 'package:sheqlee/professional/widget/general_reusable/resizesable_sliver_appbar.dart';
import 'package:sheqlee/professional/widget/subscription/subscription.dart';
import 'package:sheqlee/professional/widget/tags/tags_state.dart';

class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  late ScrollController _scrollController; // Use late

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Important!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 4,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. THE RESIZING HEADER
            SliverPersistentHeader(
              pinned: true,
              delegate: DynamicSliverHeader(title: 'Tags', showSearch: true),
            ),

            // 2. THE TAGS LIST
            tagsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xffa06cd5)),
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text("Error loading tags: $err")),
              ),
              // Inside your TagsScreen data: (tags) block
              data: (tags) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final Tag tag =
                          tags[index]; // Now it is a Tag object, not a Map

                      return _buildTagCard(
                        name: tag.name,
                        desc: tag.description,
                        tagId: tag.id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TagDetailScreen(tag: tag),
                            ),
                          );
                        },
                      );
                    }, childCount: tags.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagCard({
    required String name,
    required String desc,
    required String tagId,
    required VoidCallback onTap, // Add this parameter
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffEEEEEE))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: const TextStyle(fontSize: 14, color: Color(0xff555555)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Calls the separate provider automatically
                TagStatsRow(tagId: tagId),
                const Spacer(),
                AppSubscribeBell(id: tagId, type: 'tag', size: 23),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
