import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/obstetric_calculation_result.dart';

/// Use case for calculating obstetric dates (EDD and GA)
class CalculateObstetric {
  /// Calculates EDD using Naegele's rule and gestational age
  ObstetricCalculationResult execute({
    required DateTime lmp,
    required DateTime today,
  }) {
    // Calculate EDD using Naegele's rule
    final eddCalculation = calculateEDD(lmp);

    // Calculate gestational age
    final gaCalculation = calculateGestationalAge(lmp, today);

    // Create EDD calculation steps
    final eddSteps = EddCalculationSteps(
      step1Add7Days: eddCalculation.step1Add7Days,
      step2Subtract3Months: eddCalculation.step2Subtract3Months,
      step3Add1Year: eddCalculation.step3Add1Year,
    );

    return ObstetricCalculationResult(
      lmp: lmp,
      today: today,
      edd: eddCalculation.edd,
      gestationalAgeWeeks: gaCalculation['weeks']!,
      gestationalAgeDays: gaCalculation['days']!,
      totalDays: gaCalculation['totalDays']!,
      eddSteps: eddSteps,
    );
  }
}
