/// Entity representing urine output and AKI staging calculation result
class UrineOutputAkiResult {
  final double currentVolume;
  final double previousVolume;
  final double urineVolume; // current - previous
  final double timeHours;
  final double weightKg;
  final double urineOutputMlPerKgPerHr;
  final UrineOutputInterpretation urineOutputInterpretation;
  final AkiStage akiStage;
  final String clinicalMessage;

  const UrineOutputAkiResult({
    required this.currentVolume,
    required this.previousVolume,
    required this.urineVolume,
    required this.timeHours,
    required this.weightKg,
    required this.urineOutputMlPerKgPerHr,
    required this.urineOutputInterpretation,
    required this.akiStage,
    required this.clinicalMessage,
  });
}

/// Urine output interpretation categories
enum UrineOutputInterpretation {
  oliguria, // < 0.5 mL/kg/hr
  normal, // 0.5–2.0 mL/kg/hr
  polyuria, // > 2.0 mL/kg/hr
}

/// KDIGO AKI stage based on urine output criteria
enum AkiStage {
  noAki, // No AKI by urine output criteria
  stage1, // Stage 1 AKI
  stage2, // Stage 2 AKI
  stage3, // Stage 3 AKI
}
