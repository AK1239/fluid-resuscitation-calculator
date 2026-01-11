import 'package:chemical_app/features/obstetric_calculator/domain/entities/obstetric_calculation_result.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/use_cases/calculate_obstetric.dart';

/// Repository implementation for obstetric calculations
class ObstetricRepositoryImpl {
  final CalculateObstetric _calculateObstetric;

  ObstetricRepositoryImpl({
    CalculateObstetric? calculateObstetric,
  }) : _calculateObstetric =
            calculateObstetric ?? CalculateObstetric();

  /// Calculates EDD and gestational age
  ObstetricCalculationResult calculate({
    required DateTime lmp,
    required DateTime today,
  }) {
    return _calculateObstetric.execute(
      lmp: lmp,
      today: today,
    );
  }
}
