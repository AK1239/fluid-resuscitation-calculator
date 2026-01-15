import 'package:chemical_app/features/obstetric_calculator/domain/entities/ultrasound_calculation_result.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/use_cases/calculate_ultrasound_ga.dart';

/// Repository implementation for ultrasound-based GA calculations
class UltrasoundRepositoryImpl {
  final CalculateUltrasoundGa _calculateUltrasoundGa;

  UltrasoundRepositoryImpl({
    CalculateUltrasoundGa? calculateUltrasoundGa,
  }) : _calculateUltrasoundGa =
            calculateUltrasoundGa ?? CalculateUltrasoundGa();

  /// Calculates current gestational age from ultrasound dating
  UltrasoundCalculationResult calculate({
    required DateTime ultrasoundDate,
    required int gaWeeks,
    required int gaDays,
    required DateTime calculationDate,
  }) {
    return _calculateUltrasoundGa.execute(
      ultrasoundDate: ultrasoundDate,
      gaWeeks: gaWeeks,
      gaDays: gaDays,
      calculationDate: calculationDate,
    );
  }
}
