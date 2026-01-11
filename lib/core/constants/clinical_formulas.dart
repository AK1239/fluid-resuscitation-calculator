/// Pure Dart functions for clinical calculations
/// All formulas are based on standard medical guidelines

/// Calculates fluid deficit in mL
/// Formula: 10 × weight (kg) × % dehydration
double calculateFluidDeficit(double weightKg, double dehydrationPercent) {
  return 10 * weightKg * dehydrationPercent;
}

/// Calculates maintenance fluids for adults
/// Default: 35 mL/kg/day
double calculateMaintenanceFluids(double weightKg) {
  return 35 * weightKg;
}

/// Calculates hourly maintenance fluid rate
double calculateHourlyMaintenanceRate(double dailyMaintenance) {
  return dailyMaintenance / 24;
}

/// Calculates maintenance fluids for children using Holliday-Segar method
/// 0-10 kg → 4 mL/kg/hr
/// 10-20 kg → 40 mL/hr + 2 mL/kg/hr for each kg >10
/// >20 kg → 60 mL/hr + 1 mL/kg/hr for each kg >20
double calculatePediatricMaintenanceFluidsHourly(double weightKg) {
  if (weightKg <= 0) return 0.0;
  
  if (weightKg <= 10) {
    // 0-10 kg: 4 mL/kg/hr
    return 4 * weightKg;
  } else if (weightKg <= 20) {
    // 10-20 kg: 40 mL/hr + 2 mL/kg/hr for each kg >10
    final excessKg = weightKg - 10;
    return 40 + (2 * excessKg);
  } else {
    // >20 kg: 60 mL/hr + 1 mL/kg/hr for each kg >20
    final excessKg = weightKg - 20;
    return 60 + (1 * excessKg);
  }
}

/// Calculates sodium correction
/// Male: 0.6 × BW × (target − current)
/// Female: 0.5 × BW × (target − current)
double calculateSodiumCorrection({
  required bool isMale,
  required double weightKg,
  required double currentNa,
  required double targetNa,
}) {
  final factor = isMale ? 0.6 : 0.5;
  return factor * weightKg * (targetNa - currentNa);
}

/// Calculates volume of 3% NS needed for sodium correction
/// 3% NS contains 513 mEq/L of sodium
double calculateVolumeOf3PercentNS(double sodiumRequiredMEq) {
  const sodiumConcentrationMEqPerL = 513.0;
  return (sodiumRequiredMEq / sodiumConcentrationMEqPerL) *
      1000; // Convert to mL
}

/// Calculates potassium correction using 1.5× deficit rule
/// Required mmol K = 1.5 × (target - current) × weight (kg)
double calculatePotassiumCorrection({
  required double weightKg,
  required double currentK,
  required double targetK,
}) {
  return 1.5 * (targetK - currentK) * weightKg;
}

/// Calculates approximate number of Slow-K tablets needed
/// Each Slow-K tablet contains 8 mmol of potassium
int calculateSlowKTablets(double potassiumRequiredMMol) {
  const potassiumPerTablet = 8.0;
  return (potassiumRequiredMMol / potassiumPerTablet).ceil();
}

/// Calculates fluid resuscitation phase volumes
class FluidResuscitationPhases {
  final double phase1Volume; // ½ deficit over 30 minutes
  final double phase2DeficitVolume; // ¼ deficit
  final double phase3DeficitVolume; // ¼ deficit
  final double phase2TotalVolume; // Maintenance + ¼ deficit over 8 hours
  final double phase3TotalVolume; // Maintenance + ¼ deficit over 16 hours
  final double phase2HourlyRate; // Hourly rate for phase 2
  final double phase3HourlyRate; // Hourly rate for phase 3

  FluidResuscitationPhases({
    required this.phase1Volume,
    required this.phase2DeficitVolume,
    required this.phase3DeficitVolume,
    required this.phase2TotalVolume,
    required this.phase3TotalVolume,
    required this.phase2HourlyRate,
    required this.phase3HourlyRate,
  });
}

/// Calculates fluid resuscitation phases
FluidResuscitationPhases calculateFluidResuscitationPhases({
  required double totalDeficit,
  required double maintenanceFluidsPerDay,
}) {
  final phase1Volume = totalDeficit / 2; // ½ deficit
  final phase2DeficitVolume = totalDeficit / 4; // ¼ deficit
  final phase3DeficitVolume = totalDeficit / 4; // ¼ deficit

  final maintenancePerHour = maintenanceFluidsPerDay / 24;
  final phase2Maintenance = maintenancePerHour * 8; // 8 hours
  final phase3Maintenance = maintenancePerHour * 16; // 16 hours

  final phase2TotalVolume = phase2Maintenance + phase2DeficitVolume;
  final phase3TotalVolume = phase3Maintenance + phase3DeficitVolume;

  final phase2HourlyRate = phase2TotalVolume / 8;
  final phase3HourlyRate = phase3TotalVolume / 16;

  return FluidResuscitationPhases(
    phase1Volume: phase1Volume,
    phase2DeficitVolume: phase2DeficitVolume,
    phase3DeficitVolume: phase3DeficitVolume,
    phase2TotalVolume: phase2TotalVolume,
    phase3TotalVolume: phase3TotalVolume,
    phase2HourlyRate: phase2HourlyRate,
    phase3HourlyRate: phase3HourlyRate,
  );
}

/// Calculates insulin dosing using 2/3-1/3 rule
/// Returns a map with all calculated values
/// TDD = factor × weight (kg), where factor is typically 0.3-0.5 U/kg/day
/// Morning dose: 2/3 of TDD
///   - 2/3 Insoluble (NPH)
///   - 1/3 Soluble (Regular)
/// Evening dose: 1/3 of TDD
///   - 1/2 Insoluble (NPH)
///   - 1/2 Soluble (Regular)
Map<String, double> calculateInsulinDosing({
  required double weightKg,
  double tddFactor = 0.5, // Default 0.5 U/kg/day (typical adult range: 0.3-0.5)
}) {
  // Step 1: Calculate Total Daily Dose (TDD)
  final totalDailyDose = tddFactor * weightKg;

  // Step 2: Split by time of day
  final morningDoseTotal = (totalDailyDose * 2 / 3);
  final eveningDoseTotal = (totalDailyDose * 1 / 3);

  // Step 3: Split each dose into insoluble vs soluble
  // Morning dose: 2/3 Insoluble, 1/3 Soluble
  final morningInsoluble = (morningDoseTotal * 2 / 3);
  final morningSoluble = (morningDoseTotal * 1 / 3);

  // Evening dose: 1/2 Insoluble, 1/2 Soluble
  final eveningInsoluble = (eveningDoseTotal * 1 / 2);
  final eveningSoluble = (eveningDoseTotal * 1 / 2);

  return {
    'totalDailyDose': totalDailyDose,
    'morningDoseTotal': morningDoseTotal,
    'morningInsoluble': morningInsoluble,
    'morningSoluble': morningSoluble,
    'eveningDoseTotal': eveningDoseTotal,
    'eveningInsoluble': eveningInsoluble,
    'eveningSoluble': eveningSoluble,
  };
}

/// Obstetric calculation result using Naegele's rule
class ObstetricCalculation {
  final DateTime edd;
  final DateTime step1Add7Days;
  final DateTime step2Subtract3Months;
  final DateTime step3Add1Year;

  ObstetricCalculation({
    required this.edd,
    required this.step1Add7Days,
    required this.step2Subtract3Months,
    required this.step3Add1Year,
  });
}

/// Calculates Estimated Date of Delivery (EDD) using Naegele's rule
/// Formula: EDD = LMP + 7 days − 3 months + 1 year
ObstetricCalculation calculateEDD(DateTime lmp) {
  // Step 1: LMP + 7 days
  final step1Add7Days = lmp.add(const Duration(days: 7));

  // Step 2: Step 1 - 3 months
  DateTime step2Subtract3Months;
  if (step1Add7Days.month >= 4) {
    step2Subtract3Months = DateTime(
      step1Add7Days.year,
      step1Add7Days.month - 3,
      step1Add7Days.day,
    );
  } else {
    // Handle year rollover
    step2Subtract3Months = DateTime(
      step1Add7Days.year - 1,
      step1Add7Days.month + 9, // 12 - 3 = 9
      step1Add7Days.day,
    );
  }

  // Step 3: Step 2 + 1 year (final EDD)
  final step3Add1Year = DateTime(
    step2Subtract3Months.year + 1,
    step2Subtract3Months.month,
    step2Subtract3Months.day,
  );

  return ObstetricCalculation(
    edd: step3Add1Year,
    step1Add7Days: step1Add7Days,
    step2Subtract3Months: step2Subtract3Months,
    step3Add1Year: step3Add1Year,
  );
}

/// Calculates gestational age from LMP to today
/// Returns a map with totalDays, weeks, and days
Map<String, int> calculateGestationalAge(DateTime lmp, DateTime today) {
  final difference = today.difference(lmp);
  final totalDays = difference.inDays;

  final weeks = totalDays ~/ 7;
  final days = totalDays % 7;

  return {
    'totalDays': totalDays,
    'weeks': weeks,
    'days': days,
  };
}
