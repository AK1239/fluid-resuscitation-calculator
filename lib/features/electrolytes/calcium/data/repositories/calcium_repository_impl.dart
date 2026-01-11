import 'package:chemical_app/features/electrolytes/calcium/domain/entities/calcium_correction_result.dart';
import 'package:chemical_app/features/electrolytes/calcium/domain/use_cases/calculate_calcium_correction.dart';

/// Repository implementation for calcium correction
class CalciumRepositoryImpl {
  final CalculateCalciumCorrection _calculateCalciumCorrection;

  CalciumRepositoryImpl({
    CalculateCalciumCorrection? calculateCalciumCorrection,
  }) : _calculateCalciumCorrection =
            calculateCalciumCorrection ?? CalculateCalciumCorrection();

  /// Calculates calcium correction
  CalciumCorrectionResult calculate({
    required double weightKg,
    required double currentCa,
    required bool isSymptomatic,
  }) {
    return _calculateCalciumCorrection.execute(
      weightKg: weightKg,
      currentCa: currentCa,
      isSymptomatic: isSymptomatic,
    );
  }
}

