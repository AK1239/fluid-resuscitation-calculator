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
    } else {
      return RenalFunctionStage.kidneyFailure;
    }
  }

  /// Gets dose adjustment guidance based on renal function stage
  String _getDoseAdjustmentGuidance(RenalFunctionStage stage) {
    switch (stage) {
      case RenalFunctionStage.normal:
        return 'No dose adjustment needed. Standard dose appropriate.';
      case RenalFunctionStage.mildImpairment:
        return 'Mild renal impairment. Consider 75-100% of standard dose. Monitor for drug accumulation.';
      case RenalFunctionStage.moderateImpairment:
        return 'Moderate renal impairment. Reduce dose to 50-75% of standard dose or extend dosing interval.';
      case RenalFunctionStage.severeImpairment:
        return 'Severe renal impairment. Reduce dose to 25-50% of standard dose or significantly extend dosing interval.';
      case RenalFunctionStage.kidneyFailure:
        return 'Kidney failure (CrCl < 15). Use 25% of standard dose or avoid if contraindicated. Consider alternative medications.';
    }
  }

  /// Calculates adjusted dose based on renal function
  /// This is a general guideline; specific drugs may have different recommendations
  double? _calculateAdjustedDose(
    double standardDose,
    RenalFunctionStage stage,
  ) {
    switch (stage) {
      case RenalFunctionStage.normal:
        return null; // No adjustment needed
      case RenalFunctionStage.mildImpairment:
        return (standardDose * 0.875).roundToDouble(); // ~87.5% (midpoint of 75-100%)
      case RenalFunctionStage.moderateImpairment:
        return (standardDose * 0.625).roundToDouble(); // ~62.5% (midpoint of 50-75%)
      case RenalFunctionStage.severeImpairment:
        return (standardDose * 0.375).roundToDouble(); // ~37.5% (midpoint of 25-50%)
      case RenalFunctionStage.kidneyFailure:
        return (standardDose * 0.25).roundToDouble(); // 25%
    }
  }

  /// Executes the calculation
  RenalDoseAdjustmentResult execute({
    required int age,
    required bool isMale,
    required double weightKg,
    required double serumCreatinineUmolPerL,
    required double standardDose,
  }) {
    // Convert creatinine to mg/dL
    final serumCreatinineMgPerDl =
        _convertCreatinineToMgPerDl(serumCreatinineUmolPerL);

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

    // Get dose adjustment guidance
    final guidance = _getDoseAdjustmentGuidance(stage);

    // Calculate adjusted dose
    final adjustedDose = _calculateAdjustedDose(standardDose, stage);

    return RenalDoseAdjustmentResult(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinine: serumCreatinineUmolPerL,
      serumCreatinineMgPerDl: serumCreatinineMgPerDl,
      standardDose: standardDose,
      creatinineClearance: roundedCrCl,
      renalFunctionStage: stage,
      adjustedDose: adjustedDose,
      doseAdjustmentGuidance: guidance,
    );
  }
}
