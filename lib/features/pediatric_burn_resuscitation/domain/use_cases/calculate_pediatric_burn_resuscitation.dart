import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/domain/entities/pediatric_burn_resuscitation_result.dart';

/// Use case for calculating pediatric burn fluid resuscitation using Parkland formula + maintenance fluids
class CalculatePediatricBurnResuscitation {
  /// Calculates pediatric burn fluid resuscitation using Parkland formula + Holliday-Segar maintenance
  /// Formula: Total burn fluid (24h) = 4 mL × weight (kg) × %TBSA
  /// Maintenance: Holliday-Segar method
  /// Total hourly rate = Burn resuscitation rate + Maintenance rate
  PediatricBurnResuscitationResult execute({
    required int ageYears,
    required double weightKg,
    required double tbsaPercent,
    required int timeSinceBurnHours,
    required bool hasInhalationInjury,
    required bool hasElectricalInjury,
  }) {
    // Check if patient meets indication for formal fluid resuscitation
    // Pediatrics: ≥10% TBSA, or any burn with shock, electrical injury, or inhalation injury
    final meetsIndication =
        tbsaPercent >= 10 || hasInhalationInjury || hasElectricalInjury;

    // Calculate total 24-hour burn resuscitation fluid using Parkland formula
    // Total fluid (24h) = 4 mL × weight (kg) × %TBSA
    final totalBurnFluid24h = 4 * weightKg * tbsaPercent;

    // First 8 hours: 50% of total volume
    final first8hVolume = totalBurnFluid24h * 0.5;

    // Calculate remaining time in first 8-hour period
    final first8hRemainingHours = (8 - timeSinceBurnHours).clamp(1, 8);

    // If patient presents late (after 8 hours), still calculate but note the adjustment
    final first8hHourlyRate = first8hRemainingHours > 0
        ? first8hVolume / first8hRemainingHours
        : 0.0;

    // Next 16 hours: Remaining 50% of total volume
    final next16hVolume = totalBurnFluid24h * 0.5;
    final next16hHourlyRate = next16hVolume / 16;

    // Calculate maintenance fluids using Holliday-Segar method (hourly rate)
    final maintenanceFluidHourlyRate =
        calculatePediatricMaintenanceFluidsHourly(weightKg);

    // Calculate total hourly rates (burn + maintenance)
    final first8hTotalHourlyRate =
        first8hHourlyRate + maintenanceFluidHourlyRate;
    final next16hTotalHourlyRate =
        next16hHourlyRate + maintenanceFluidHourlyRate;

    // Determine urine output target
    // Infants (<1 year): ≥1-1.5 mL/kg/hr
    // Children: ≥1 mL/kg/hr
    // Electrical burns: ≥1-1.5 mL/kg/hr
    final isInfant = ageYears < 1;
    final urineOutputTarget = (isInfant || hasElectricalInjury) ? 1.5 : 1.0;

    return PediatricBurnResuscitationResult(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasElectricalInjury: hasElectricalInjury,
      meetsIndication: meetsIndication,
      totalBurnFluid24h: totalBurnFluid24h,
      first8hVolume: first8hVolume,
      first8hRemainingHours: first8hRemainingHours,
      first8hHourlyRate: first8hHourlyRate,
      next16hVolume: next16hVolume,
      next16hHourlyRate: next16hHourlyRate,
      maintenanceFluidHourlyRate: maintenanceFluidHourlyRate,
      first8hTotalHourlyRate: first8hTotalHourlyRate,
      next16hTotalHourlyRate: next16hTotalHourlyRate,
      urineOutputTarget: urineOutputTarget,
    );
  }
}
