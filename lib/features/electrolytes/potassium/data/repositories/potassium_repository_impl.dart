import 'package:chemical_app/features/electrolytes/potassium/domain/entities/potassium_correction_result.dart';
import 'package:chemical_app/features/electrolytes/potassium/domain/use_cases/calculate_potassium_correction.dart';

/// Repository implementation for potassium correction
class PotassiumRepositoryImpl {
  final CalculatePotassiumCorrection _calculatePotassiumCorrection;

  PotassiumRepositoryImpl({
    CalculatePotassiumCorrection? calculatePotassiumCorrection,
  }) : _calculatePotassiumCorrection =
            calculatePotassiumCorrection ?? CalculatePotassiumCorrection();

  /// Calculates potassium correction
  PotassiumCorrectionResult calculate({
    required double weightKg,
    required double currentK,
    required double targetK,
  }) {
    return _calculatePotassiumCorrection.execute(
      weightKg: weightKg,
      currentK: currentK,
      targetK: targetK,
    );
  }
}

