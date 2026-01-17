import 'package:chemical_app/features/renal_dose_adjustment/domain/entities/renal_dose_adjustment_result.dart';

/// Use case for calculating renal dose adjustment
class CalculateRenalDoseAdjustment {
  /// Converts serum creatinine from μmol/L to mg/dL
  /// Conversion factor: 1 mg/dL = 88.4 μmol/L
  double _convertCreatinineToMgPerDl(double creatinineUmolPerL) {
    return creatinineUmolPerL / 88.4;
  }

  /// Calculates Creatinine Clearance using Cockcroft-Gault equation
  /// Formula: CrCl = [(140 - age) × weight × (0.85 if female)] / (72 × SCr)
  /// Where SCr is in mg/dL
  double _calculateCreatinineClearance({
    required int age,
    required bool isMale,
    required double weightKg,
    required double serumCreatinineMgPerDl,
  }) {
    if (serumCreatinineMgPerDl <= 0) {
      throw ArgumentError('Serum creatinine must be greater than 0');
    }

    final ageFactor = 140 - age;
    final weightFactor = weightKg;
    final genderFactor = isMale ? 1.0 : 0.85;
    final creatinineFactor = 72 * serumCreatinineMgPerDl;

    final crCl = (ageFactor * weightFactor * genderFactor) / creatinineFactor;

    // Cap at reasonable maximum (typically 150 mL/min)
    return crCl > 150 ? 150.0 : crCl;
  }

  /// Determines renal function stage based on CrCl
  RenalFunctionStage _determineRenalFunctionStage(double crCl) {
    if (crCl >= 90) {
      return RenalFunctionStage.normal;
    } else if (crCl >= 60) {
      return RenalFunctionStage.mildImpairment;
    } else if (crCl >= 30) {
      return RenalFunctionStage.moderateImpairment;
    } else if (crCl >= 15) {
      return RenalFunctionStage.severeImpairment;
    } else if (crCl >= 10) {
      return RenalFunctionStage.kidneyFailure;
    } else {
      return RenalFunctionStage.kidneyFailure;
    }
  }

  /// Executes the calculation
  RenalDoseAdjustmentResult execute({
    required int age,
    required bool isMale,
    required double weightKg,
    required double serumCreatinineUmolPerL,
  }) {
    // Convert creatinine to mg/dL
    final serumCreatinineMgPerDl = _convertCreatinineToMgPerDl(
      serumCreatinineUmolPerL,
    );

    // Calculate CrCl
    final crCl = _calculateCreatinineClearance(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinineMgPerDl: serumCreatinineMgPerDl,
    );

    // Round CrCl to 1 decimal place
    final roundedCrCl = (crCl * 10).roundToDouble() / 10;

    // Determine renal function stage
    final stage = _determineRenalFunctionStage(roundedCrCl);

    // Check if CrCl < 10 mL/min (requires dialysis consideration)
    final requiresDialysis = roundedCrCl < 10;

    return RenalDoseAdjustmentResult(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinine: serumCreatinineUmolPerL,
      serumCreatinineMgPerDl: serumCreatinineMgPerDl,
      creatinineClearance: roundedCrCl,
      renalFunctionStage: stage,
      requiresDialysis: requiresDialysis,
    );
  }
}
