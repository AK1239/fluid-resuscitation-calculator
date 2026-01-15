/// Entity representing pregnant insulin dosing calculation result
class PregnantInsulinResult {
  final double maternalWeightKg;
  final String trimester;
  final String obesityClass;
  final String currentRegimen;
  final double totalDailyDose; // TDD in units
  final bool requiresFourInjectionRegimen;
  
  // Standard initial regimen (mild-moderate hyperglycemia)
  final double? morningNph;
  final double? morningRapidActing;
  
  // Four-injection regimen
  final double? morningBasal; // 2/3 of morning dose (2/3 of TDD)
  final double? morningRapidActingFourInjection; // 1/3 of morning dose
  final double? dinnerRapidActing; // 1/2 of evening dose (1/3 of TDD)
  final double? bedtimeBasal; // 1/2 of evening dose
  final double? lunchRapidActing; // Optional
  
  // Adjustments based on glucose pattern
  final List<String> adjustments;
  final List<InjectionDose> injectionSchedule;

  const PregnantInsulinResult({
    required this.maternalWeightKg,
    required this.trimester,
    required this.obesityClass,
    required this.currentRegimen,
    required this.totalDailyDose,
    required this.requiresFourInjectionRegimen,
    this.morningNph,
    this.morningRapidActing,
    this.morningBasal,
    this.morningRapidActingFourInjection,
    this.dinnerRapidActing,
    this.bedtimeBasal,
    this.lunchRapidActing,
    required this.adjustments,
    required this.injectionSchedule,
  });
}

/// Represents a single injection dose with timing
class InjectionDose {
  final String timing; // e.g., "Before breakfast", "Before dinner", "Bedtime"
  final String insulinType; // e.g., "NPH", "Rapid-acting (lispro/aspart)", "Long-acting (glargine)"
  final double units;
  final String? rationale;

  const InjectionDose({
    required this.timing,
    required this.insulinType,
    required this.units,
    this.rationale,
  });
}
