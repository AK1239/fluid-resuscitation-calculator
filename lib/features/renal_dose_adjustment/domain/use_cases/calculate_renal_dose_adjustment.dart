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

  /// Gets dose adjustment guidance based on CrCl
  String _getDoseAdjustmentGuidance(
    double crCl,
    double standardDose,
    double? adjustedDose,
    double standardInterval,
    double? adjustedInterval,
  ) {
    if (crCl >= 90) {
      return 'No dose adjustment needed. Standard dose appropriate.';
    } else if (crCl < 10) {
      return 'Severe kidney failure (CrCl < 10 mL/min). Consider dialysis-dependent dosing or alternative medications. Consult nephrology.';
    } else if (adjustedDose != null && adjustedInterval != null) {
      final dosePercent = ((adjustedDose / standardDose) * 100).toStringAsFixed(0);
      return 'Renal impairment detected. Consider dose reduction to ${adjustedDose.toStringAsFixed(0)} mg (${dosePercent}% of standard) or extend interval to ${adjustedInterval.toStringAsFixed(1)} hours. Therapeutic drug monitoring recommended.';
    } else if (adjustedInterval != null) {
      return 'Renal impairment detected. Consider extending dosing interval to ${adjustedInterval.toStringAsFixed(1)} hours. Therapeutic drug monitoring recommended.';
    } else {
      return 'Renal impairment detected. Dose adjustment recommended based on CrCl. Consult drug-specific dosing guidelines.';
    }
  }

  /// Calculates adjusted dose using proportional formula: Adjusted dose = Standard dose × (CrCl / 100)
  double? _calculateAdjustedDose(double standardDose, double crCl) {
    if (crCl >= 90) {
      return null; // No adjustment needed for normal renal function
    }
    // Use proportional formula
    final adjusted = standardDose * (crCl / 100);
    return adjusted > 0 ? adjusted : null;
  }

  /// Calculates adjusted interval using proportional formula: Adjusted interval = Standard interval × (100 / CrCl)
  double? _calculateAdjustedInterval(double standardInterval, double crCl) {
    if (crCl >= 90) {
      return null; // No adjustment needed for normal renal function
    }
    if (crCl <= 0) {
      return null; // Cannot calculate if CrCl is 0 or negative
    }
    // Use proportional formula
    final adjusted = standardInterval * (100 / crCl);
    return adjusted > 0 ? adjusted : null;
  }

  /// Executes the calculation
  RenalDoseAdjustmentResult execute({
    required int age,
    required bool isMale,
    required double weightKg,
    required double serumCreatinineUmolPerL,
    required double standardDose,
    required double standardInterval,
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

    // Calculate adjusted dose using proportional formula
    final adjustedDose = _calculateAdjustedDose(standardDose, roundedCrCl);

    // Calculate adjusted interval using proportional formula
    final adjustedInterval = _calculateAdjustedInterval(standardInterval, roundedCrCl);

    // Check if CrCl < 10 mL/min (requires dialysis consideration)
    final requiresDialysis = roundedCrCl < 10;

    // Get dose adjustment guidance
    final guidance = _getDoseAdjustmentGuidance(
      roundedCrCl,
      standardDose,
      adjustedDose,
      standardInterval,
      adjustedInterval,
    );

    return RenalDoseAdjustmentResult(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinine: serumCreatinineUmolPerL,
      serumCreatinineMgPerDl: serumCreatinineMgPerDl,
      standardDose: standardDose,
      standardInterval: standardInterval,
      creatinineClearance: roundedCrCl,
      renalFunctionStage: stage,
      adjustedDose: adjustedDose,
      adjustedInterval: adjustedInterval,
      doseAdjustmentGuidance: guidance,
      requiresDialysis: requiresDialysis,
    );
  }
}
