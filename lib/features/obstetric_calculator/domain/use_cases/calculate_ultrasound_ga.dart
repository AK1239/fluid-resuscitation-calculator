import 'package:chemical_app/features/obstetric_calculator/domain/entities/ultrasound_calculation_result.dart';

/// Use case for calculating current gestational age based on ultrasound dating
class CalculateUltrasoundGa {
  /// Calculates current gestational age from ultrasound dating
  /// 
  /// Algorithm:
  /// 1. Convert ultrasound GA (weeks + days) into total days
  /// 2. Calculate days elapsed between ultrasound date and calculation date
  /// 3. Add elapsed days to original GA days to get current total GA days
  /// 4. Convert back to weeks + days format
  UltrasoundCalculationResult execute({
    required DateTime ultrasoundDate,
    required int gaWeeks,
    required int gaDays,
    required DateTime calculationDate,
    bool calculateEdd = true,
  }) {
    // Validate: days must be 0-6
    if (gaDays < 0 || gaDays >= 7) {
      throw ArgumentError('GA days must be between 0 and 6');
    }

    // Validate: ultrasound date should not be in the future
    if (ultrasoundDate.isAfter(calculationDate)) {
      throw ArgumentError('Ultrasound date cannot be in the future');
    }

    // Step 1: Convert ultrasound GA to total days
    final totalGaDaysAtUltrasound = (gaWeeks * 7) + gaDays;

    // Step 2: Calculate days elapsed between ultrasound date and calculation date
    final daysElapsed = calculationDate.difference(ultrasoundDate).inDays;

    // Step 3: Add elapsed days to original GA days
    final totalCurrentGaDays = totalGaDaysAtUltrasound + daysElapsed;

    // Step 4: Convert back to weeks + days
    final currentGaWeeks = totalCurrentGaDays ~/ 7; // Integer division
    final currentGaDays = totalCurrentGaDays % 7; // Remainder

    // Optional: Calculate EDD (assuming 280 days = 40 weeks from ultrasound GA)
    DateTime? edd;
    if (calculateEdd) {
      edd = ultrasoundDate.add(Duration(days: 280 - totalGaDaysAtUltrasound));
    }

    return UltrasoundCalculationResult(
      ultrasoundDate: ultrasoundDate,
      gaWeeksAtUltrasound: gaWeeks,
      gaDaysAtUltrasound: gaDays,
      calculationDate: calculationDate,
      currentGaWeeks: currentGaWeeks,
      currentGaDays: currentGaDays,
      totalGaDaysAtUltrasound: totalGaDaysAtUltrasound,
      daysElapsed: daysElapsed,
      totalCurrentGaDays: totalCurrentGaDays,
      edd: edd,
    );
  }
}
