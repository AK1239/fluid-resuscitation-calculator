/// Entity representing renal dose adjustment calculation result
class RenalDoseAdjustmentResult {
  final int age;
  final bool isMale;
  final double weightKg;
  final double serumCreatinine; // in μmol/L
  final double serumCreatinineMgPerDl; // converted to mg/dL
  final double standardDose;
  final double standardInterval; // in hours
  final double creatinineClearance; // CrCl in mL/min
  final RenalFunctionStage renalFunctionStage;
  final double? adjustedDose;
  final double? adjustedInterval; // in hours
  final String doseAdjustmentGuidance;
  final bool requiresDialysis;

  const RenalDoseAdjustmentResult({
    required this.age,
    required this.isMale,
    required this.weightKg,
    required this.serumCreatinine,
    required this.serumCreatinineMgPerDl,
    required this.standardDose,
    required this.standardInterval,
    required this.creatinineClearance,
    required this.renalFunctionStage,
    this.adjustedDose,
    this.adjustedInterval,
    required this.doseAdjustmentGuidance,
    required this.requiresDialysis,
  });
}

/// Renal function staging based on CrCl
enum RenalFunctionStage {
  normal, // CrCl > 90 mL/min
  mildImpairment, // CrCl 60-90 mL/min
  moderateImpairment, // CrCl 30-59 mL/min
  severeImpairment, // CrCl 15-29 mL/min
  kidneyFailure, // CrCl < 15 mL/min
}
