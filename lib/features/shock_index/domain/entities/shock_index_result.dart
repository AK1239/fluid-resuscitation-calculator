/// Entity representing Shock Index and TASI calculation result
class ShockIndexResult {
  final double heartRate;
  final double systolicBp;
  final double? age;
  final double shockIndex;
  final double? traumaAdjustedShockIndex;
  final ShockIndexInterpretation shockIndexInterpretation;
  final TraumaAdjustedShockIndexInterpretation? tasiInterpretation;

  const ShockIndexResult({
    required this.heartRate,
    required this.systolicBp,
    this.age,
    required this.shockIndex,
    this.traumaAdjustedShockIndex,
    required this.shockIndexInterpretation,
    this.tasiInterpretation,
  });
}

/// Shock Index interpretation categories
enum ShockIndexInterpretation {
  normal, // < 0.5
  borderline, // 0.5–0.9
  highRisk, // ≥ 0.9
  severe, // ≥ 1.0
}

/// Trauma-Adjusted Shock Index interpretation categories
enum TraumaAdjustedShockIndexInterpretation {
  lowRisk, // < 40
  moderateRisk, // 40–79
  highRisk, // 80–119
  veryHighRisk, // ≥ 120
}
