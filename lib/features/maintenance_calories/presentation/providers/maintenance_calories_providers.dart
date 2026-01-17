import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/maintenance_calories/data/repositories/maintenance_calories_repository_impl.dart';
import 'package:chemical_app/features/maintenance_calories/domain/entities/maintenance_calories_result.dart';

/// Repository provider
final maintenanceCaloriesRepositoryProvider =
    Provider<MaintenanceCaloriesRepositoryImpl>((ref) {
  return MaintenanceCaloriesRepositoryImpl();
});

/// Form state
class MaintenanceCaloriesFormState {
  final String? weightKg;
  final PatientCategory? category;
  final double? kcalPerKgPerDay; // Chosen caloric target within range

  const MaintenanceCaloriesFormState({
    this.weightKg,
    this.category,
    this.kcalPerKgPerDay,
  });

  MaintenanceCaloriesFormState copyWith({
    String? weightKg,
    PatientCategory? category,
    double? kcalPerKgPerDay,
  }) {
    return MaintenanceCaloriesFormState(
      weightKg: weightKg ?? this.weightKg,
      category: category ?? this.category,
      kcalPerKgPerDay: kcalPerKgPerDay ?? this.kcalPerKgPerDay,
    );
  }

  bool get isValid {
    if (weightKg == null || weightKg!.isEmpty || category == null) {
      return false;
    }

    final weight = double.tryParse(weightKg!);
    if (weight == null || weight <= 0 || weight > 500) {
      return false;
    }

    // If category is set, kcalPerKgPerDay must be within range
    if (category != null && kcalPerKgPerDay == null) {
      return false;
    }

    if (category != null && kcalPerKgPerDay != null) {
      final range = PatientCategoryRange.ranges[category]!;
      if (kcalPerKgPerDay! < range.minKcalPerKgPerDay ||
          kcalPerKgPerDay! > range.maxKcalPerKgPerDay) {
        return false;
      }
    }

    return true;
  }
}

/// Form state notifier
class MaintenanceCaloriesFormNotifier
    extends StateNotifier<MaintenanceCaloriesFormState> {
  MaintenanceCaloriesFormNotifier()
      : super(const MaintenanceCaloriesFormState());

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setCategory(PatientCategory? category) {
    // When category changes, reset kcalPerKgPerDay to midpoint of new range
    double? newKcalPerKgPerDay;
    if (category != null) {
      final range = PatientCategoryRange.ranges[category]!;
      newKcalPerKgPerDay = range.midpointKcalPerKgPerDay;
    }
    state = state.copyWith(category: category, kcalPerKgPerDay: newKcalPerKgPerDay);
  }

  void setKcalPerKgPerDay(double? kcalPerKgPerDay) {
    state = state.copyWith(kcalPerKgPerDay: kcalPerKgPerDay);
  }

  void reset() {
    state = const MaintenanceCaloriesFormState();
  }
}

final maintenanceCaloriesFormProvider =
    StateNotifierProvider<MaintenanceCaloriesFormNotifier,
        MaintenanceCaloriesFormState>((ref) {
  return MaintenanceCaloriesFormNotifier();
});

/// Calculation result provider
final maintenanceCaloriesResultProvider =
    Provider.autoDispose<MaintenanceCaloriesResult?>((ref) {
  final formState = ref.watch(maintenanceCaloriesFormProvider);
  final repository = ref.watch(maintenanceCaloriesRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weightKg = double.parse(formState.weightKg!);
    final category = formState.category!;
    final kcalPerKgPerDay = formState.kcalPerKgPerDay!;

    return repository.calculate(
      weightKg: weightKg,
      category: category,
      kcalPerKgPerDay: kcalPerKgPerDay,
    );
  } catch (e) {
    return null;
  }
});