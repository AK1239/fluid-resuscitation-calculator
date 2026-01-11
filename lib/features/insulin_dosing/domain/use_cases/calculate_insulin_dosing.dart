import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/insulin_dosing/domain/entities/insulin_dosing_result.dart';

/// Use case for calculating insulin dosing
class CalculateInsulinDosing {
  /// Calculates insulin dosing based on patient weight
  InsulinDosingResult execute({
    required double weightKg,
    double tddFactor = 0.5, // Default 0.5 U/kg/day (typical adult range: 0.3-0.5)
  }) {
    // Calculate insulin dosing using 2/3-1/3 rule
    final result = calculateInsulinDosing(
      weightKg: weightKg,
      tddFactor: tddFactor,
    );

    return InsulinDosingResult(
      totalDailyDose: result['totalDailyDose']!,
      morningDoseTotal: result['morningDoseTotal']!,
      morningInsoluble: result['morningInsoluble']!,
      morningSoluble: result['morningSoluble']!,
      eveningDoseTotal: result['eveningDoseTotal']!,
      eveningInsoluble: result['eveningInsoluble']!,
      eveningSoluble: result['eveningSoluble']!,
    );
  }
}
