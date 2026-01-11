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

/// Filter state
class ChartFilterState {
  final String? selectedCategory; // null means "All"
  final String? selectedGender; // null means "All", 'boys' or 'girls'

  const ChartFilterState({
    this.selectedCategory,
    this.selectedGender,
  });

  ChartFilterState copyWith({
    String? selectedCategory,
    String? selectedGender,
  }) {
    return ChartFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}

/// Filter state notifier
class ChartFilterNotifier extends StateNotifier<ChartFilterState> {
  ChartFilterNotifier() : super(const ChartFilterState());

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setGender(String? gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void reset() {
    state = const ChartFilterState();
  }
}

final chartFilterProvider =
    StateNotifierProvider<ChartFilterNotifier, ChartFilterState>((ref) {
  return ChartFilterNotifier();
});
