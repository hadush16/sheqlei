import 'package:flutter/material.dart';

class CustomScrollableField extends StatefulWidget {
  final dynamic label;
  final Widget content;
  final int itemCount;

  const CustomScrollableField({
    super.key,
    required this.label,
    required this.content,
    required this.itemCount,
  });

  @override
  State<CustomScrollableField> createState() => _CustomScrollableFieldState();
}

class _CustomScrollableFieldState extends State<CustomScrollableField> {
  // 1. Initialize the controller here so it persists
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // 2. Clean up memory when the widget is removed
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isScrollable = widget.itemCount >= -1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Handling
            widget.label is String
                ? Text(
                    widget.label,
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  )
                : widget.label,
            const SizedBox(height: 8),

            // Scrollable Area
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: isScrollable ? 70 : 160),
              child: RawScrollbar(
                controller: _scrollController,
                thumbVisibility: isScrollable,
                thickness: 6,
                thumbColor: Colors.black, // Your black scroll icon
                radius: const Radius.circular(10),
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  // If 2 or fewer items, we disable scrolling to prevent the error
                  physics: isScrollable
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(right: isScrollable ? 18 : 0),
                    child: widget.content,
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
