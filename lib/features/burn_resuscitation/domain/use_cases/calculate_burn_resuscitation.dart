import 'package:chemical_app/features/burn_resuscitation/domain/entities/burn_resuscitation_result.dart';

/// Use case for calculating burn fluid resuscitation using Parkland formula
class CalculateBurnResuscitation {
  /// Calculates burn fluid resuscitation using Parkland formula
  /// Formula: Total fluid (24h) = 4 mL × weight (kg) × %TBSA
  BurnResuscitationResult execute({
    required int ageYears,
    required double weightKg,
    required double tbsaPercent,
    required int timeSinceBurnHours,
    required bool hasInhalationInjury,
    required bool hasUrineOutputAvailable,
  }) {
    // Check if patient meets indication for formal fluid resuscitation
    final isChild = ageYears < 18;
    final meetsIndication = isChild
        ? tbsaPercent >= 10
        : tbsaPercent >= 10; // Adults typically ≥10-15%, using 10% as minimum

    // Calculate total 24-hour fluid using Parkland formula
    // Total fluid (24h) = 4 mL × weight (kg) × %TBSA
    final totalFluid24h = 4 * weightKg * tbsaPercent;

    // First 8 hours: 50% of total volume
    final first8hVolume = totalFluid24h * 0.5;

    // Calculate remaining time in first 8-hour period
    final first8hRemainingHours = (8 - timeSinceBurnHours).clamp(1, 8);
    
    // If patient presents late (after 8 hours), still calculate but note the adjustment
    final first8hHourlyRate = first8hRemainingHours > 0
        ? first8hVolume / first8hRemainingHours
        : 0.0;

    // Next 16 hours: Remaining 50% of total volume
    final next16hVolume = totalFluid24h * 0.5;
    final next16hHourlyRate = next16hVolume / 16;

    // Determine urine output target
    // Adults: ≥0.5 mL/kg/hr, Children: ≥1 mL/kg/hr
    final urineOutputTarget = isChild ? 1.0 : 0.5;

    return BurnResuscitationResult(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasUrineOutputAvailable: hasUrineOutputAvailable,
      meetsIndication: meetsIndication,
      totalFluid24h: totalFluid24h,
      first8hVolume: first8hVolume,
      first8hRemainingHours: first8hRemainingHours,
      first8hHourlyRate: first8hHourlyRate,
      next16hVolume: next16hVolume,
      next16hHourlyRate: next16hHourlyRate,
      urineOutputTarget: urineOutputTarget,
    );
  }
}
