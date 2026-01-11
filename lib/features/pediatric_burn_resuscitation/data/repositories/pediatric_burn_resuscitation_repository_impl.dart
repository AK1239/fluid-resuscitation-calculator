import 'package:chemical_app/features/pediatric_burn_resuscitation/domain/entities/pediatric_burn_resuscitation_result.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/domain/use_cases/calculate_pediatric_burn_resuscitation.dart';

/// Repository implementation for pediatric burn resuscitation calculations
class PediatricBurnResuscitationRepositoryImpl {
  final CalculatePediatricBurnResuscitation _calculatePediatricBurnResuscitation;

  PediatricBurnResuscitationRepositoryImpl({
    CalculatePediatricBurnResuscitation? calculatePediatricBurnResuscitation,
  }) : _calculatePediatricBurnResuscitation =
            calculatePediatricBurnResuscitation ??
            CalculatePediatricBurnResuscitation();

  /// Calculates pediatric burn fluid resuscitation using Parkland formula + maintenance fluids
  PediatricBurnResuscitationResult calculate({
    required int ageYears,
    required double weightKg,
    required double tbsaPercent,
    required int timeSinceBurnHours,
    required bool hasInhalationInjury,
    required bool hasElectricalInjury,
  }) {
    return _calculatePediatricBurnResuscitation.execute(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasElectricalInjury: hasElectricalInjury,
    );
  }
}
