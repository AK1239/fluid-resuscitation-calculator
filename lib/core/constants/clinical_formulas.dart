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
