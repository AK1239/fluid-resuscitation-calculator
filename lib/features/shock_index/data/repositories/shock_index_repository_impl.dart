import 'package:chemical_app/features/shock_index/domain/entities/shock_index_result.dart';
import 'package:chemical_app/features/shock_index/domain/use_cases/calculate_shock_index.dart';

/// Repository implementation for Shock Index calculation
class ShockIndexRepositoryImpl {
  final CalculateShockIndex _calculateShockIndex;

  ShockIndexRepositoryImpl({
    CalculateShockIndex? calculateShockIndex,
  }) : _calculateShockIndex =
            calculateShockIndex ?? CalculateShockIndex();

  /// Calculates Shock Index and TASI
  ShockIndexResult calculate({
    required double heartRate,
    required double systolicBp,
    double? age,
  }) {
    return _calculateShockIndex.execute(
      heartRate: heartRate,
      systolicBp: systolicBp,
      age: age,
    );
  }
}
