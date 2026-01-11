import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

/// Use case for calculating sodium correction
class CalculateSodiumCorrection {
  /// Calculates sodium correction based on patient parameters
  SodiumCorrectionResult execute({
    required bool isMale,
    required double weightKg,
    required double currentNa,
    required double targetNa,
  }) {
    // Calculate sodium required
    final sodiumRequiredMEq = calculateSodiumCorrection(
      isMale: isMale,
      weightKg: weightKg,
      currentNa: currentNa,
      targetNa: targetNa,
    );

    // Calculate volume of 3% NS needed
    final volumeOf3PercentNS = calculateVolumeOf3PercentNS(sodiumRequiredMEq);

    return SodiumCorrectionResult(
      sodiumRequiredMEq: sodiumRequiredMEq,
      volumeOf3PercentNS: volumeOf3PercentNS,
    );
  }
}

