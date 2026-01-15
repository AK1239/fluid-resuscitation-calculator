/// Entity representing norepinephrine infusion calculation result
class NorepinephrineResult {
  final double weightKg;
  final double doseUgPerKgPerMin;
  final double concentrationUgPerMl; // Standard: 80 µg/mL
  final double dosePerMinute; // Total dose per minute in µg/min
  final double dosePerHour; // Total dose per hour in µg/hour
  final double infusionRateMlPerHour; // Final infusion rate in mL/hr

  const NorepinephrineResult({
    required this.weightKg,
    required this.doseUgPerKgPerMin,
    required this.concentrationUgPerMl,
    required this.dosePerMinute,
    required this.dosePerHour,
    required this.infusionRateMlPerHour,
  });
}
