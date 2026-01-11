import 'package:chemical_app/features/maintenance_fluids/domain/entities/maintenance_fluid_result.dart';
import 'package:chemical_app/features/maintenance_fluids/domain/use_cases/calculate_maintenance_fluids.dart';

/// Repository implementation for maintenance fluids
class MaintenanceFluidRepositoryImpl {
  final CalculateMaintenanceFluids _calculateMaintenanceFluids;

  MaintenanceFluidRepositoryImpl({
    CalculateMaintenanceFluids? calculateMaintenanceFluids,
  }) : _calculateMaintenanceFluids =
            calculateMaintenanceFluids ?? CalculateMaintenanceFluids();

  /// Calculates maintenance fluids
  MaintenanceFluidResult calculate({
    required double weightKg,
  }) {
    return _calculateMaintenanceFluids.execute(
      weightKg: weightKg,
    );
  }
}

