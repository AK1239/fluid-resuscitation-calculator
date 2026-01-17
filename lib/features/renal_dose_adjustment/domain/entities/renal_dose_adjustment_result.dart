/// Entity representing creatinine clearance calculation result
class RenalDoseAdjustmentResult {
  final int age;
  final bool isMale;
  final double weightKg;
  final double serumCreatinine; // in μmol/L
  final double serumCreatinineMgPerDl; // converted to mg/dL
  final double creatinineClearance; // CrCl in mL/min
  final RenalFunctionStage renalFunctionStage;
  final bool requiresDialysis;

  const RenalDoseAdjustmentResult({
    required this.age,
    required this.isMale,
    required this.weightKg,
    required this.serumCreatinine,
    required this.serumCreatinineMgPerDl,
    required this.creatinineClearance,
    required this.renalFunctionStage,
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
