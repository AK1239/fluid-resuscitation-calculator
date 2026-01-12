/// Entity representing sodium correction calculation result
class SodiumCorrectionResult {
  final double sodiumRequiredMEq; // Total sodium required in mEq
  final double volumeOf3PercentNS; // Volume of 3% NS needed in mL
  final double? desiredTargetNa; // Original target entered by user
  final double safeTargetNa; // Safe target (capped at 8 mmol/L correction)
  final double correctionRate; // Actual correction rate used (mmol/L per 24h)
  final bool wasAdjusted; // Whether the target was adjusted for safety

  const SodiumCorrectionResult({
    required this.sodiumRequiredMEq,
    required this.volumeOf3PercentNS,
    this.desiredTargetNa,
    required this.safeTargetNa,
    required this.correctionRate,
    required this.wasAdjusted,
  });
}

