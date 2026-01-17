import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/calculators_repository.dart';
import '../models/calculator_model.dart';
import '../services/calculator_search_service.dart';
import '../widgets/calculator_search_bar.dart';
import '../widgets/calculator_list_header.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/calculator_category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _onSearchClear() {
    _searchController.clear();
  }

  void _onCalculatorTap(String route) {
    context.go(route);
  }

  List<CalculatorModel> get _filteredCalculators {
    return CalculatorSearchService.filterCalculators(
      CalculatorsRepository.allCalculators,
      _searchQuery,
    );
  }

  Map<String, List<CalculatorModel>> get _groupedCalculators {
    return CalculatorSearchService.groupByCategory(_filteredCalculators);
  }

  List<String> get _sortedCategories {
    final categories = _groupedCalculators.keys.toList();
    return CalculatorSearchService.sortCategories(categories);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedCalculators;
    final categories = _sortedCategories;
    final filteredCalculators = _filteredCalculators;
    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dr. Yasin Khatri',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '@med.tutor.tz',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CalculatorSearchBar(
              controller: _searchController,
              onChanged: (_) {},
              onClear: _onSearchClear,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalculatorListHeader(
                      isSearching: isSearching,
                      resultCount: filteredCalculators.length,
                    ),
                    if (filteredCalculators.isEmpty)
                      const EmptySearchState()
                    else
                      ...categories.map((category) {
                        return CalculatorCategorySection(
                          category: category,
                          calculators: grouped[category]!,
                          showCategoryTitle:
                              !isSearching || categories.length > 1,
                          onCalculatorTap: _onCalculatorTap,
                        );
                      }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
