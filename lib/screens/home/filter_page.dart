//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/providers/filter_provider.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/widget/backbutton.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _isSearching = _searchController.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterAsync = ref.watch(filterDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 25, right: 25),
            child: filterAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (data) => Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _isSearching
                        ? _buildSearchSuggestions(data)
                        : _buildDefaultView(data),
                  ),
                ],
              ),
            ),
          ),
          _buildFixedBackButton(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 42,
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search",
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SvgPicture.asset(
                    'assets/icons/search-alt2 (1).svg',
                    height: 18,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset('assets/icons/filter - alt2.svg', width: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultView(FilterData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Non-selectable Chips
        Wrap(
          spacing: 6,
          runSpacing: 10,
          children: data.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                tag.name,
                style: const TextStyle(color: Colors.black, fontSize: 13),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: data.categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  data.categories[index].name,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: SvgPicture.asset(
                  'assets/icons/arrow-down-sign-to-navigate (1).svg',
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions(FilterData data) {
    final query = _searchController.text.toLowerCase();

    // Filters categories based on typing
    final suggestions = data.categories
        .where((cat) => cat.name.toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          // Design similar to the image: Icon in front of the text
          leading: SvgPicture.asset(
            'assets/icons/search-alt2 (1).svg',
            height: 18,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          title: Text(
            suggestions[index].name,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          onTap: () {
            _searchController.text = suggestions[index].name;
            FocusScope.of(context).unfocus();
            // Add navigation or filtering logic here
          },
        );
      },
    );
  }

  Widget _buildFixedBackButton() {
    return Positioned(
      top: 89,
      left: 25,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainShellScreen(username: 'username'),
          ),
        ),
        child: const AppBackButton(),
      ),
    );
  }
}
