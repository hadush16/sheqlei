import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheqlee/models/filter_model.dart';
import 'package:sheqlee/providers/filter/job_filter_logic_provider.dart';
import 'package:sheqlee/providers/filter/filter_provider.dart';
import 'package:sheqlee/providers/filter/filtered_provider.dart';
import 'package:sheqlee/providers/filter/tags_search_provider.dart';
import 'package:sheqlee/screens/fitter/jobfilter_page_dropdwon.dart';
import 'package:sheqlee/screens/home/main_shell_screen.dart';
import 'package:sheqlee/widget/login/backbutton.dart';
import 'package:sheqlee/widget/home/job_card.dart';

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
              loading: () {
                return null;
              }, //=> const Center(child: CircularProgressIndicator()),
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
    final jobsAsync = ref.watch(tagFilteredJobsProvider);
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
      //error: (err, _) => Center(child: Text("Error loading jobs")),
      // Inside _buildFilteredResultsList
      error: (err, stack) {
        print("Search Error: $err"); // Check your console!
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text("Search failed: ${err.toString()}"),
              TextButton(
                onPressed: () => ref.refresh(filteredJobsProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      },
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
              // onSubmitted: (value) {
              //   // Trigger the search query update
              //   ref.read(filterSearchProvider.notifier).updateQuery(value);
              // },
              // Inside _buildSearchBar
              onSubmitted: (value) {
                // 1. Update the global search query
                ref.read(filterSearchProvider.notifier).updateQuery(value);

                // 2. Hide suggestions and show the Job list
                setState(() {
                  _showResults = true;
                  _isSearching = false; // Hide the suggestions list
                });

                // 3. Remove keyboard focus
                FocusScope.of(context).unfocus();
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
            // onPressed: () {
            //   // This NAVIGATES to your new Filter Page
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const JobFilterPage()),
            //   );
            // },
            onPressed: () async {
              // Navigate to dropdown page
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobFilterPage()),
              );

              // After returning from the JobFilterPage, check if filters were applied
              final criteria = ref.read(jobFilterCriteriaProvider);
              if (criteria.isApplied) {
                setState(() => _showResults = true);
              }
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
              return GestureDetector(
                // Inside FilterScreen _buildDefaultView or suggestions
                onTap: () {
                  _searchController.text = tag.name; // Use the name for the UI

                  // Try changing this line:
                  // Option A: Send the ID (if backend expects ObjectId)
                  ref.read(filterSearchProvider.notifier).setSearchTag(tag.id);

                  // Option B: Send the NAME (if backend expects a string search)
                  // ref.read(filterSearchProvider.notifier).updateQuery(tag.name);

                  setState(() => _showResults = true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    tag.name,
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                  ),
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
          MaterialPageRoute(builder: (context) => const MainShellScreen()),
        ),
        child: const AppBackButton(),
      ),
    );
  }
}
