import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/providers/tags/tag_provider_for_jobcount.dart';

class TagStatsRow extends ConsumerWidget {
  final String tagId;
  const TagStatsRow({super.key, required this.tagId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(tagStatsProvider(tagId));

    return stats.when(
      data: (val) => Row(
        children: [
          _pill("${val['jobs']} Jobs"),
          const SizedBox(width: 10),
          _pill("${val['subs']} Subs"),
        ],
      ),
      loading: () => _pill("..."),
      error: (_, __) => _pill("0"),
    );
  }

  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffCCCCCC)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
