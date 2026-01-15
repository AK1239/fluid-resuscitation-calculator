import 'package:chemical_app/features/norepinephrine/domain/entities/norepinephrine_result.dart';

/// Use case for calculating norepinephrine infusion rate
class CalculateNorepinephrine {
  /// Standard concentration: 4 mg in 50 mL of 5% dextrose = 80 µg/mL
  static const double standardConcentrationUgPerMl = 80.0;

  /// Calculates norepinephrine infusion rate based on patient parameters
  /// Formula: Infusion rate (mL/hr) = (Dose (µg/kg/min) × Weight (kg) × 60) / Concentration (µg/mL)
  NorepinephrineResult execute({
    required double weightKg,
    required double doseUgPerKgPerMin,
    double? customConcentrationUgPerMl,
  }) {
    final concentration = customConcentrationUgPerMl ?? standardConcentrationUgPerMl;

    // Step 1: Calculate dose per minute (µg/min)
    final dosePerMinute = doseUgPerKgPerMin * weightKg;

    // Step 2: Convert to dose per hour (µg/hour)
    final dosePerHour = dosePerMinute * 60;

    // Step 3: Calculate infusion rate (mL/hour)
    final infusionRateMlPerHour = dosePerHour / concentration;

    return NorepinephrineResult(
      weightKg: weightKg,
      doseUgPerKgPerMin: doseUgPerKgPerMin,
      concentrationUgPerMl: concentration,
      dosePerMinute: dosePerMinute,
      dosePerHour: dosePerHour,
      infusionRateMlPerHour: infusionRateMlPerHour,
    );
  }
}
