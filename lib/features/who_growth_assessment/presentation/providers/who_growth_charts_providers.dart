import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/who_growth_assessment/data/repositories/who_growth_charts_repository.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_chart.dart';

/// Repository provider
final whoGrowthChartsRepositoryProvider =
    Provider<WhoGrowthChartsRepository>((ref) {
  return WhoGrowthChartsRepository();
});

/// Charts provider
final whoGrowthChartsProvider =
    Provider<List<WhoGrowthChartCategory>>((ref) {
  final repository = ref.watch(whoGrowthChartsRepositoryProvider);
  return repository.getCharts();
});
