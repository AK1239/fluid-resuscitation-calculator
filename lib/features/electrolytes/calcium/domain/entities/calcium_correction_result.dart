/// Entity representing calcium correction calculation result
class CalciumCorrectionResult {
  final double estimatedDeficit; // Estimated calcium deficit in mg
  final String ivGuidance; // IV calcium gluconate guidance
  final String oralSupplementation; // Oral supplementation info

  const CalciumCorrectionResult({
    required this.estimatedDeficit,
    required this.ivGuidance,
    required this.oralSupplementation,
  });
}

