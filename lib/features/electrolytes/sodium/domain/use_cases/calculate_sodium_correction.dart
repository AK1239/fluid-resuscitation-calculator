import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

/// Use case for calculating sodium correction
class CalculateSodiumCorrection {
  /// Maximum safe correction rate per 24 hours (mmol/L)
  static const double maxSafeCorrectionRate = 8.0;

  /// Calculates sodium correction based on patient parameters
  /// Automatically caps correction rate at 8 mmol/L per 24 hours for safety
  SodiumCorrectionResult execute({
    required bool isMale,
    required double weightKg,
    required double currentNa,
    required double targetNa,
  }) {
    // Calculate desired correction rate
    final desiredCorrectionRate = targetNa - currentNa;
    
    // Cap correction rate at safe maximum (8 mmol/L per 24 hours)
    final safeCorrectionRate = desiredCorrectionRate > maxSafeCorrectionRate
        ? maxSafeCorrectionRate
        : desiredCorrectionRate;
    
    // Calculate safe target (current + safe correction rate)
    final safeTargetNa = currentNa + safeCorrectionRate;
    final wasAdjusted = desiredCorrectionRate > maxSafeCorrectionRate;

    // Calculate sodium required using safe target
    final sodiumRequiredMEq = calculateSodiumCorrection(
      isMale: isMale,
      weightKg: weightKg,
      currentNa: currentNa,
      targetNa: safeTargetNa,
    );

    // Calculate volume of 3% NS needed
    final volumeOf3PercentNS = calculateVolumeOf3PercentNS(sodiumRequiredMEq);

    return SodiumCorrectionResult(
      sodiumRequiredMEq: sodiumRequiredMEq,
      volumeOf3PercentNS: volumeOf3PercentNS,
      desiredTargetNa: wasAdjusted ? targetNa : null,
      safeTargetNa: safeTargetNa,
      correctionRate: safeCorrectionRate,
      wasAdjusted: wasAdjusted,
    );
  }
}

