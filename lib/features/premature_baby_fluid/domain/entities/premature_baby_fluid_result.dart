/// Entity representing premature baby fluid calculation result
class PrematureBabyFluidResult {
  final GestationalCategory gestationalCategory;
  final int dayOfLife;
  final double currentWeightKg;
  final bool canTakeEbm;
  final Environment environment;
  final bool hasSevereHie;
  final bool hasAki;
  final bool hasCerebralEdema;
  final bool hasMultiOrganDamage;

  // Calculated values
  final double baselineFluidMlPerKgPerDay;
  final double ebmMlPerKgPerDay;
  final double enteralVolumeMlPerDay;
  final double clinicalRestrictionPercent;
  final double environmentalIncrementMlPerKgPerDay;
  final double totalAdjustedFluidMlPerDay;
  final double finalIvFluidVolumeMlPerDay;
  final double ivRateMlPerHour;
  final FluidType fluidType;
  final String fluidComposition;
  final List<String> adjustmentsApplied;
  final List<String> safetyNotes;

  const PrematureBabyFluidResult({
    required this.gestationalCategory,
    required this.dayOfLife,
    required this.currentWeightKg,
    required this.canTakeEbm,
    required this.environment,
    required this.hasSevereHie,
    required this.hasAki,
    required this.hasCerebralEdema,
    required this.hasMultiOrganDamage,
    required this.baselineFluidMlPerKgPerDay,
    required this.ebmMlPerKgPerDay,
    required this.enteralVolumeMlPerDay,
    required this.clinicalRestrictionPercent,
    required this.environmentalIncrementMlPerKgPerDay,
    required this.totalAdjustedFluidMlPerDay,
    required this.finalIvFluidVolumeMlPerDay,
    required this.ivRateMlPerHour,
    required this.fluidType,
    required this.fluidComposition,
    required this.adjustmentsApplied,
    required this.safetyNotes,
  });
}

/// Gestational category
enum GestationalCategory {
  pretermLessThan1000g,
  pretermLessThan35wGreaterThan1000g,
  termNeonate,
}

/// Environment type
enum Environment {
  none,
  phototherapy,
  radiantWarmer,
}

/// Fluid type
enum FluidType {
  d10w, // Day 0
  d10_02ns, // Day 1+
}