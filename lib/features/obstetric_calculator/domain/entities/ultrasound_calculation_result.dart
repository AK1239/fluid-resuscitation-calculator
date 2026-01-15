/// Entity representing ultrasound-based gestational age calculation result
class UltrasoundCalculationResult {
  final DateTime ultrasoundDate;
  final int gaWeeksAtUltrasound;
  final int gaDaysAtUltrasound;
  final DateTime calculationDate; // Today or selected date
  final int currentGaWeeks;
  final int currentGaDays;
  final int totalGaDaysAtUltrasound;
  final int daysElapsed;
  final int totalCurrentGaDays;
  final DateTime? edd; // Optional EDD based on ultrasound GA

  const UltrasoundCalculationResult({
    required this.ultrasoundDate,
    required this.gaWeeksAtUltrasound,
    required this.gaDaysAtUltrasound,
    required this.calculationDate,
    required this.currentGaWeeks,
    required this.currentGaDays,
    required this.totalGaDaysAtUltrasound,
    required this.daysElapsed,
    required this.totalCurrentGaDays,
    this.edd,
  });
}
