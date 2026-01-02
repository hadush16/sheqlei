//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/providers/filter_provider.dart';
import 'package:sheqlee/providers/jobs/filtered_provider.dart';
import 'package:sheqlee/screens/home/jobfilter_page_dropdwon.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/job_card.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  // 1. Add this to track if we should show the final Job List
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
        // Reset results view if user clears text completely
        if (_searchController.text.isEmpty) _showResults = false;
      });
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
              loading:
                  () {}, //=> const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (data) => Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _showResults
                        ? _buildFilteredResultsList() // 2. Show the actual jobs
                        : (_isSearching
                              ? _buildSearchSuggestions(data)
                              : _buildDefaultView(data)),
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

  Widget _buildFilteredResultsList() {
    final jobsAsync = ref.watch(filteredJobsProvider);

    return jobsAsync.when(
      data: (jobs) => jobs.isEmpty
          ? const Center(child: Text("No jobs found matching your criteria"))
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: jobs.length,
              itemBuilder: (context, index) =>
                  JobCard(job: jobs[index]), // Use your JobCard widget here
            ),
      loading: () => const Center(
        //child: CircularProgressIndicator(color: Color(0xff8967B3)),
      ),
      error: (err, _) => Center(child: Text("Error loading jobs")),
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
              cursorColor: Color(0xff8967B3),
              onSubmitted: (value) {
                // Trigger the search query update
                ref.read(filterSearchProvider.notifier).updateQuery(value);
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search",
                prefixIconConstraints: const BoxConstraints(minWidth: 0),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SvgPicture.asset(
                    'assets/icons/search-alt2 (1).svg',
                    height: 20,
                    width: 20,
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
        // Container(
        //   height: 42,
        //   width: 42,
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.black),
        //     borderRadius: BorderRadius.circular(50),
        //   ),
        //   child: IconButton(
        //     padding: EdgeInsets.zero,
        //     icon: SvgPicture.asset('assets/icons/filter - alt2.svg', width: 20),
        //     onPressed: () {},
        //   ),
        // ),
        // Inside your _buildSearchBar() method in FilterScreen
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
            ), // Changed to light gray for better design
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset('assets/icons/filter - alt2.svg', width: 20),
            onPressed: () {
              // This NAVIGATES to your new Filter Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobFilterPage()),
              );
            },
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
        ConstrainedBox(
          constraints: BoxConstraints(
            // Calculate: (Tag Height + runSpacing) * rows
            // Height is approx: Padding(12) + TextSize(13) + Border = ~35-40
            maxHeight: 70,
          ),
          child: Wrap(
            clipBehavior: Clip.hardEdge, // This hides the 3rd row
            spacing: 5,
            runSpacing: 8,
            children: data.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  // Widget _buildSearchSuggestions(FilterData data) {
  //   final query = _searchController.text.toLowerCase();

  //   // Filters categories based on typing
  //   final suggestions = data.tags
  //       .where((Tag) => Tag.name.toLowerCase().contains(query))
  //       .toList();

  //   return ListView.builder(
  //     padding: EdgeInsets.zero,
  //     itemCount: suggestions.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         // Design similar to the image: Icon in front of the text
  //         leading: SvgPicture.asset(
  //           'assets/icons/search-alt2 (1).svg',
  //           height: 18,
  //           colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
  //         ),
  //         title: Text(
  //           suggestions[index].name,
  //           style: const TextStyle(fontSize: 16, color: Colors.black87),
  //         ),
  //         onTap: () {
  //           final selectedTag = suggestions[index];
  //           _searchController.text = selectedTag.name;

  //           // 1. Update the filter state
  //           ref
  //               .read(filterSearchProvider.notifier)
  //               .setSearchTag(selectedTag.id);

  //           // 2. Clear focus
  //           FocusScope.of(context).unfocus();

  //           // 3. Since the FilteredJobsNotifier 'watches' filterSearchProvider,
  //           // it will automatically start loading the new list.
  //         },
  //       );
  //     },
  //   );
  // }
  // 4. Update the onTap logic in your suggestions
  Widget _buildSearchSuggestions(FilterData data) {
    final query = _searchController.text.toLowerCase();
    final suggestions = data.tags
        .where((tag) => tag.name.toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final selectedTag = suggestions[index];
        return ListTile(
          leading: SvgPicture.asset(
            'assets/icons/search-alt2 (2).svg',
            height: 18,
          ),
          title: Text(selectedTag.name),
          onTap: () {
            _searchController.text = selectedTag.name;
            ref
                .read(filterSearchProvider.notifier)
                .setSearchTag(selectedTag.id);
            FocusScope.of(context).unfocus();

            // 5. TRIGGER RESULTS VIEW
            setState(() => _showResults = true);
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
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sheqlee/models/filter_model.dart';
// import 'package:sheqlee/providers/filter_provider.dart'; // Ensure this has the filterSearchProvider
// import 'package:sheqlee/widget/backbutton.dart';

// class FilterScreen extends ConsumerStatefulWidget {
//   const FilterScreen({super.key});

//   @override
//   ConsumerState<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends ConsumerState<FilterScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize search controller with current global search query if any
//     _searchController.text = ref.read(filterSearchProvider).searchQuery;

//     _searchController.addListener(() {
//       setState(() => _isSearching = _searchController.text.isNotEmpty);
//       // Sync text input with global search provider
//       ref
//           .read(filterSearchProvider.notifier)
//           .updateQuery(_searchController.text);
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filterAsync = ref.watch(filterDataProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 150, left: 25, right: 25),
//             child: filterAsync.when(
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (err, _) => Center(child: Text('Error: $err')),
//               data: (data) => Column(
//                 children: [
//                   _buildSearchBar(),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: _isSearching
//                         ? _buildSearchSuggestions(data)
//                         : _buildDefaultView(data),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           _buildFixedBackButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: SizedBox(
//             height: 42,
//             child: TextField(
//               controller: _searchController,
//               textAlignVertical: TextAlignVertical.center,
//               decoration: InputDecoration(
//                 isDense: true,
//                 hintText: "Search",
//                 prefixIconConstraints: const BoxConstraints(minWidth: 40),
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: SvgPicture.asset(
//                     'assets/icons/search-alt2 (1).svg',
//                     height: 18,
//                   ),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         _buildFilterIconButton(),
//       ],
//     );
//   }

//   Widget _buildFilterIconButton() {
//     return Container(
//       height: 42,
//       width: 42,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(50),
//       ),
//       child: IconButton(
//         padding: EdgeInsets.zero,
//         icon: SvgPicture.asset('assets/icons/filter - alt2.svg', width: 20),
//         onPressed: () {
//           // You could open a sub-filter modal here if needed
//         },
//       ),
//     );
//   }

//   Widget _buildDefaultView(FilterData data) {
//     final activeTagId = ref.watch(filterSearchProvider).activeTagId;

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Dynamic & Selectable Tags
//           Wrap(
//             spacing: 8,
//             runSpacing: 10,
//             children: data.tags.map((tag) {
//               final isSelected = activeTagId == tag.id;
//               return GestureDetector(
//                 onTap: () {
//                   ref.read(filterSearchProvider.notifier).setSearchTag(tag.id);
//                   _searchController.text = tag.name; // Visual feedback
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? const Color(0xffa06cd5).withOpacity(0.1)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(50),
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xffa06cd5)
//                           : Colors.black,
//                     ),
//                   ),
//                   child: Text(
//                     tag.name,
//                     style: TextStyle(
//                       color: isSelected
//                           ? const Color(0xffa06cd5)
//                           : Colors.black,
//                       fontWeight: isSelected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 30),

//           const SizedBox(height: 10),
//           // Categories List
//           _buildCategoryList(data.categories),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryList(List<Category> categories) {
//     final activeCatId = ref.watch(filterSearchProvider).activeCategoryId;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.zero,
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         final isSelected = activeCatId == category.id;

//         return ListTile(
//           onTap: () {
//             ref
//                 .read(filterSearchProvider.notifier)
//                 .setSearchCategory(category.id);
//             Navigator.pop(context); // Return to home to see results
//           },
//           contentPadding: EdgeInsets.zero,
//           title: Text(
//             category.name,
//             style: TextStyle(
//               fontSize: 16,
//               color: isSelected ? const Color(0xffa06cd5) : Colors.black87,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           trailing: SvgPicture.asset(
//             'assets/icons/arrow-down-sign-to-navigate (1).svg',
//             colorFilter: isSelected
//                 ? const ColorFilter.mode(Color(0xffa06cd5), BlendMode.srcIn)
//                 : null,
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchSuggestions(FilterData data) {
//     final query = _searchController.text.toLowerCase();
//     final suggestions = data.categories
//         .where((cat) => cat.name.toLowerCase().contains(query))
//         .toList();

//     return ListView.builder(
//       padding: EdgeInsets.zero,
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: const Icon(Icons.search, size: 18, color: Colors.grey),
//           title: Text(suggestions[index].name),
//           onTap: () {
//             ref
//                 .read(filterSearchProvider.notifier)
//                 .setSearchCategory(suggestions[index].id);
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildFixedBackButton() {
//     return Positioned(
//       top: 89,
//       left: 25,
//       child: GestureDetector(
//         onTap: () =>
//             Navigator.pop(context), // Use pop to return to previous state
//         child: const AppBackButton(),
//       ),
//     );
//   }
// }
