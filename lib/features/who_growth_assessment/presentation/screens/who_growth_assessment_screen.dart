import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/features/who_growth_assessment/presentation/providers/who_growth_charts_providers.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_chart.dart';

class WhoGrowthAssessmentScreen extends ConsumerWidget {
  const WhoGrowthAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charts = ref.watch(whoGrowthChartsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WHO Growth Charts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _buildBody(context, charts),
    );
  }

  Widget _buildBody(BuildContext context, List<WhoGrowthChartCategory> charts) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _calculateItemCount(charts),
      itemBuilder: (context, index) {
        final item = _getItemAtIndex(index, charts);
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

  int _calculateItemCount(List<WhoGrowthChartCategory> charts) {
    int count = 0;
    for (final category in charts) {
      count++; // Category header
      if (category.boysCharts.isNotEmpty) {
        count++; // Boys header
        count += category.boysCharts.length; // Boys charts
      }
      if (category.girlsCharts.isNotEmpty) {
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
  ) {
    int currentIndex = 0;
    final totalContentItems = _calculateItemCount(charts) - 2;

    // Content items
    for (final category in charts) {
      // Category header
      if (currentIndex == index) {
        return _CategoryHeaderItem(category.displayName);
      }
      currentIndex++;

      // Boys section
      if (category.boysCharts.isNotEmpty) {
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
      if (category.girlsCharts.isNotEmpty) {
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
