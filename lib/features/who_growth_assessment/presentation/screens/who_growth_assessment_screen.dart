import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/features/who_growth_assessment/presentation/providers/who_growth_charts_providers.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_chart.dart';

class WhoGrowthAssessmentScreen extends ConsumerStatefulWidget {
  const WhoGrowthAssessmentScreen({super.key});

  @override
  ConsumerState<WhoGrowthAssessmentScreen> createState() =>
      _WhoGrowthAssessmentScreenState();
}

class _WhoGrowthAssessmentScreenState
    extends ConsumerState<WhoGrowthAssessmentScreen> {
  @override
  Widget build(BuildContext context) {
    final charts = ref.watch(whoGrowthChartsProvider);
    final filterState = ref.watch(chartFilterProvider);
    final filterNotifier = ref.read(chartFilterProvider.notifier);

    // Filter charts based on selection
    final filteredCharts = _filterCharts(charts, filterState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WHO Growth Charts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(context, charts, filterState, filterNotifier),
          Expanded(child: _buildBody(context, filteredCharts)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    List<WhoGrowthChartCategory> allCharts,
    ChartFilterState filterState,
    ChartFilterNotifier filterNotifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryDropdown(
              context,
              allCharts,
              filterState.selectedCategory,
              (value) => filterNotifier.setCategory(value),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildGenderDropdown(
              context,
              filterState.selectedGender,
              (value) => filterNotifier.setGender(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(
    BuildContext context,
    List<WhoGrowthChartCategory> categories,
    String? selectedCategory,
    ValueChanged<String?> onChanged,
  ) {
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: null,
        child: Text('All Categories'),
      ),
      ...categories.map(
        (category) => DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.displayName),
        ),
      ),
    ];

    return DropdownButtonFormField<String?>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildGenderDropdown(
    BuildContext context,
    String? selectedGender,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String?>(
      value: selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      items: const [
        DropdownMenuItem<String>(value: null, child: Text('All')),
        DropdownMenuItem<String>(value: 'boys', child: Text('Boys')),
        DropdownMenuItem<String>(value: 'girls', child: Text('Girls')),
      ],
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  List<WhoGrowthChartCategory> _filterCharts(
    List<WhoGrowthChartCategory> charts,
    ChartFilterState filterState,
  ) {
    if (filterState.selectedCategory == null &&
        filterState.selectedGender == null) {
      return charts;
    }

    return charts.where((category) {
      // Filter by category
      if (filterState.selectedCategory != null &&
          category.name != filterState.selectedCategory) {
        return false;
      }

      // Filter by gender - only include if category has charts for selected gender
      if (filterState.selectedGender == 'boys' && category.boysCharts.isEmpty) {
        return false;
      }
      if (filterState.selectedGender == 'girls' &&
          category.girlsCharts.isEmpty) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildBody(BuildContext context, List<WhoGrowthChartCategory> charts) {
    final filterState = ref.watch(chartFilterProvider);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _calculateItemCount(charts, filterState),
      itemBuilder: (context, index) {
        final item = _getItemAtIndex(index, charts, filterState);
        if (item == null) {
          return const SizedBox.shrink();
        }

        if (item is _CategoryHeaderItem) {
          return _buildCategoryHeader(context, item.title);
        } else if (item is _GenderSubheaderItem) {
          return _buildGenderSubheader(context, item.gender);
        } else if (item is _ChartImageItem) {
          return _buildChartImage(context, item.chart);
        } else if (item is _PdfButtonItem) {
          return _buildPdfButton(context);
        } else if (item is _FooterItem) {
          return _buildFooter(context);
        }

        return const SizedBox.shrink();
      },
    );
  }

  int _calculateItemCount(
    List<WhoGrowthChartCategory> charts,
    ChartFilterState filterState,
  ) {
    int count = 0;
    for (final category in charts) {
      count++; // Category header

      final showBoys =
          filterState.selectedGender == null ||
          filterState.selectedGender == 'boys';
      final showGirls =
          filterState.selectedGender == null ||
          filterState.selectedGender == 'girls';

      if (showBoys && category.boysCharts.isNotEmpty) {
        count++; // Boys header
        count += category.boysCharts.length; // Boys charts
      }
      if (showGirls && category.girlsCharts.isNotEmpty) {
        count++; // Girls header
        count += category.girlsCharts.length; // Girls charts
      }
    }
    count += 2; // PDF button and footer
    return count;
  }

  _ListItemType? _getItemAtIndex(
    int index,
    List<WhoGrowthChartCategory> charts,
    ChartFilterState filterState,
  ) {
    int currentIndex = 0;
    final totalContentItems = _calculateItemCount(charts, filterState) - 2;

    final showBoys =
        filterState.selectedGender == null ||
        filterState.selectedGender == 'boys';
    final showGirls =
        filterState.selectedGender == null ||
        filterState.selectedGender == 'girls';

    // Content items
    for (final category in charts) {
      // Category header
      if (currentIndex == index) {
        return _CategoryHeaderItem(category.displayName);
      }
      currentIndex++;

      // Boys section
      if (showBoys && category.boysCharts.isNotEmpty) {
        if (currentIndex == index) {
          return _GenderSubheaderItem('Boys');
        }
        currentIndex++;

        for (final chart in category.boysCharts) {
          if (currentIndex == index) {
            return _ChartImageItem(chart);
          }
          currentIndex++;
        }
      }

      // Girls section
      if (showGirls && category.girlsCharts.isNotEmpty) {
        if (currentIndex == index) {
          return _GenderSubheaderItem('Girls');
        }
        currentIndex++;

        for (final chart in category.girlsCharts) {
          if (currentIndex == index) {
            return _ChartImageItem(chart);
          }
          currentIndex++;
        }
      }
    }

    // PDF button and footer
    if (index == totalContentItems) {
      return _PdfButtonItem();
    }
    if (index == totalContentItems + 1) {
      return _FooterItem();
    }

    return null;
  }

  Widget _buildCategoryHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildGenderSubheader(BuildContext context, String gender) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        gender,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildChartImage(BuildContext context, WhoGrowthChart chart) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            chart.assetPath,
            fit: BoxFit.contain,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading chart: ${chart.assetPath}');
              debugPrint('Error: $error');
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unable to load chart',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chart.assetPath,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPdfButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to PDF viewer screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF viewer functionality coming soon'),
            ),
          );
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('View official WHO PDF'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Text(
        'Source: WHO Growth Standards',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Base class for list items
abstract class _ListItemType {}

class _CategoryHeaderItem extends _ListItemType {
  final String title;
  _CategoryHeaderItem(this.title);
}

class _GenderSubheaderItem extends _ListItemType {
  final String gender;
  _GenderSubheaderItem(this.gender);
}

class _ChartImageItem extends _ListItemType {
  final WhoGrowthChart chart;
  _ChartImageItem(this.chart);
}

class _PdfButtonItem extends _ListItemType {}

class _FooterItem extends _ListItemType {}
