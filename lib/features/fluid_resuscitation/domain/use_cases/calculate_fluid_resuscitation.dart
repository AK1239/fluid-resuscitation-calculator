import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/core/constants/dehydration_ranges.dart';
import 'package:chemical_app/features/fluid_resuscitation/domain/entities/fluid_resuscitation_result.dart';

/// Use case for calculating fluid resuscitation
class CalculateFluidResuscitation {
  /// Calculates fluid resuscitation based on patient parameters
  FluidResuscitationResult execute({
    required PatientType patientType,
    required double weightKg,
    required DehydrationSeverity severity,
  }) {
    // Get dehydration percentage
    final dehydrationPercent = getDehydrationPercent(
      patientType: patientType,
      severity: severity,
    );

    // Calculate total fluid deficit
    final totalDeficit = calculateFluidDeficit(weightKg, dehydrationPercent);

    // Calculate maintenance fluids
    final maintenanceFluidsPerDay = calculateMaintenanceFluids(weightKg);

    // Calculate phases
    final phases = calculateFluidResuscitationPhases(
      totalDeficit: totalDeficit,
      maintenanceFluidsPerDay: maintenanceFluidsPerDay,
    );

    return FluidResuscitationResult(
      totalDeficit: totalDeficit,
      phase1Volume: phases.phase1Volume,
      phase1Duration: 30, // 30 minutes
      phase2DeficitVolume: phases.phase2DeficitVolume,
      phase2TotalVolume: phases.phase2TotalVolume,
      phase2Duration: 8, // 8 hours
      phase2HourlyRate: phases.phase2HourlyRate,
      phase3DeficitVolume: phases.phase3DeficitVolume,
      phase3TotalVolume: phases.phase3TotalVolume,
      phase3Duration: 16, // 16 hours
      phase3HourlyRate: phases.phase3HourlyRate,
      maintenanceFluidsPerDay: maintenanceFluidsPerDay,
    );
  }
}

