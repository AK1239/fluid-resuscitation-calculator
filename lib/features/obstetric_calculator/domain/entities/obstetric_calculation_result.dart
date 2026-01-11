/// Entity representing obstetric calculation result
class ObstetricCalculationResult {
  final DateTime lmp;
  final DateTime today;
  final DateTime edd;
  final int gestationalAgeWeeks;
  final int gestationalAgeDays;
  final int totalDays;
  final EddCalculationSteps eddSteps;

  const ObstetricCalculationResult({
    required this.lmp,
    required this.today,
    required this.edd,
    required this.gestationalAgeWeeks,
    required this.gestationalAgeDays,
    required this.totalDays,
    required this.eddSteps,
  });
}

/// Steps for EDD calculation using Naegele's rule
class EddCalculationSteps {
  final DateTime step1Add7Days; // LMP + 7 days
  final DateTime step2Subtract3Months; // Step 1 - 3 months
  final DateTime step3Add1Year; // Step 2 + 1 year (final EDD)

  const EddCalculationSteps({
    required this.step1Add7Days,
    required this.step2Subtract3Months,
    required this.step3Add1Year,
  });
}
