import 'package:chemical_app/features/maintenance_calories/domain/entities/maintenance_calories_result.dart';
import 'package:chemical_app/features/maintenance_calories/domain/use_cases/calculate_maintenance_calories.dart';

/// Repository implementation for maintenance calories calculation
class MaintenanceCaloriesRepositoryImpl {
  final CalculateMaintenanceCalories _calculateMaintenanceCalories;

  MaintenanceCaloriesRepositoryImpl({
    CalculateMaintenanceCalories? calculateMaintenanceCalories,
  }) : _calculateMaintenanceCalories =
            calculateMaintenanceCalories ?? CalculateMaintenanceCalories();

  /// Calculates maintenance calories and IV fluid volumes
  MaintenanceCaloriesResult calculate({
    required double weightKg,
    required PatientCategory category,
    required double kcalPerKgPerDay,
  }) {
    return _calculateMaintenanceCalories.execute(
      weightKg: weightKg,
      category: category,
      kcalPerKgPerDay: kcalPerKgPerDay,
    );
  }
}