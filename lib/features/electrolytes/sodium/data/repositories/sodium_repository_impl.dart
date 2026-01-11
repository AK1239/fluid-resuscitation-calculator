import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/use_cases/calculate_sodium_correction.dart';

/// Repository implementation for sodium correction
class SodiumRepositoryImpl {
  final CalculateSodiumCorrection _calculateSodiumCorrection;

  SodiumRepositoryImpl({
    CalculateSodiumCorrection? calculateSodiumCorrection,
  }) : _calculateSodiumCorrection =
            calculateSodiumCorrection ?? CalculateSodiumCorrection();

  /// Calculates sodium correction
  SodiumCorrectionResult calculate({
    required bool isMale,
    required double weightKg,
    required double currentNa,
    required double targetNa,
  }) {
    return _calculateSodiumCorrection.execute(
      isMale: isMale,
      weightKg: weightKg,
      currentNa: currentNa,
      targetNa: targetNa,
    );
  }
}

