import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/providers/category/category_provider.dart';
import 'package:sheqlee/providers/category/job_filter_logic_provider.dart';
import 'package:sheqlee/providers/jobs/level_type_notifier.dart'; // Meta data
import 'package:sheqlee/widget/backbutton.dart';
import 'package:sheqlee/widget/job_card.dart';

class JobFilterPage extends ConsumerStatefulWidget {
  const JobFilterPage({super.key});

  @override
  ConsumerState<JobFilterPage> createState() => _JobFilterPageState();
}

class _JobFilterPageState extends ConsumerState<JobFilterPage> {
  // Local state to hold the user's current selections
  String? _selectedCategoryId;
  String? _selectedTypeId;
  String? _selectedLevelId;

  @override
  Widget build(BuildContext context) {
    // 1. WATCH meta-data providers (Types, Levels, and Categories)
    final types = ref.watch(jobTypesProvider).value ?? [];
    final levels = ref.watch(jobLevelsProvider).value ?? [];

    final categories = ref.watch(jobCategoriesProvider).value ?? [];

    // Check if any filter is selected to activate the button
    bool hasSelection =
        _selectedTypeId != null ||
        _selectedLevelId != null ||
        _selectedCategoryId != null;
    return Scaffold(
      backgroundColor: Colors.white,
      // Wrap in SafeArea to handle notches and status bars
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LEFT COLUMN (Back Button + Dropdowns) ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Aligns children to the left
                      children: [
                        // 1. Back button now sits directly at the start
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const AppBackButton(),
                        ),

                        const SizedBox(
                          height: 15,
                        ), // Small gap between button and field
                        // 2. Category Dropdown
                        _customDropdown(
                          hint: "Categories",
                          value: _selectedCategoryId,
                          items: categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat.id,
                                  child: Text(cat.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategoryId = val),
                        ),

                        const SizedBox(height: 10),

                        // 3. Types and Levels Row
                        Row(
                          children: [
                            Expanded(
                              child: _customDropdown(
                                hint: "Types",
                                value: _selectedTypeId,
                                items: types
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t.id,
                                        child: Text(t.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedTypeId = val),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _customDropdown(
                                hint: "Levels",
                                value: _selectedLevelId,
                                items: levels
                                    .map(
                                      (l) => DropdownMenuItem(
                                        value: l.id,
                                        child: Text(l.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedLevelId = val),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // --- RIGHT SIDE (Apply Button) ---
                  // Adjusted padding to align with the two rows of dropdowns
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0),
                    child: GestureDetector(
                      onTap: hasSelection
                          ? () {
                              ref
                                  .read(jobFilterCriteriaProvider.notifier)
                                  .state = JobFilterState(
                                categoryId: _selectedCategoryId,
                                typeId: _selectedTypeId,
                                levelId: _selectedLevelId,
                                isApplied: true,
                              );
                            }
                          : null,
                      child: Container(
                        height: 98,
                        width: 70,
                        decoration: BoxDecoration(
                          color: hasSelection
                              ? const Color(0xff8967B3)
                              : Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 10),
            Expanded(child: _buildResultsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final filteredJobs = ref.watch(searchResultProvider);
    final criteria = ref.watch(jobFilterCriteriaProvider);

    // Case 1: Before pressing Apply
    if (!criteria.isApplied) {
      return const Center(
        child: Text("Select criteria and press Apply to search"),
      );
    }

    // Case 2: After pressing Apply, but no matches found
    if (filteredJobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            Text(
              "No jobs match these filters",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Case 3: Matches found!
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      itemCount: filteredJobs.length,
      itemBuilder: (context, index) => JobCard(job: filteredJobs[index]),
    );
  }

  Widget _customDropdown({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 20,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
