/// Entity representing sodium correction calculation result
class SodiumCorrectionResult {
  final double sodiumRequiredMEq; // Total sodium required in mEq
  final double volumeOf3PercentNS; // Volume of 3% NS needed in mL

  const SodiumCorrectionResult({
    required this.sodiumRequiredMEq,
    required this.volumeOf3PercentNS,
  });
}

