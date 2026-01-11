import 'package:chemical_app/core/constants/dehydration_ranges.dart';
import 'package:chemical_app/features/fluid_resuscitation/domain/entities/fluid_resuscitation_result.dart';
import 'package:chemical_app/features/fluid_resuscitation/domain/use_cases/calculate_fluid_resuscitation.dart';

/// Repository implementation for fluid resuscitation
class FluidResuscitationRepositoryImpl {
  final CalculateFluidResuscitation _calculateFluidResuscitation;

  FluidResuscitationRepositoryImpl({
    CalculateFluidResuscitation? calculateFluidResuscitation,
  }) : _calculateFluidResuscitation =
            calculateFluidResuscitation ?? CalculateFluidResuscitation();

  /// Calculates fluid resuscitation
  FluidResuscitationResult calculate({
    required PatientType patientType,
    required double weightKg,
    required DehydrationSeverity severity,
  }) {
    return _calculateFluidResuscitation.execute(
      patientType: patientType,
      weightKg: weightKg,
      severity: severity,
    );
  }
}

