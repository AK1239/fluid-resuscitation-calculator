/// Entity representing potassium correction calculation result
class PotassiumCorrectionResult {
  final double potassiumRequiredMMol; // Required potassium in mmol
  final int slowKTablets; // Approximate number of Slow-K tablets
  final String ivGuidance; // IV suggestion (display-only)

  const PotassiumCorrectionResult({
    required this.potassiumRequiredMMol,
    required this.slowKTablets,
    required this.ivGuidance,
  });
}

