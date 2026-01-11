import 'package:chemical_app/features/burn_resuscitation/domain/entities/burn_resuscitation_result.dart';
import 'package:chemical_app/features/burn_resuscitation/domain/use_cases/calculate_burn_resuscitation.dart';

/// Repository implementation for burn resuscitation calculations
class BurnResuscitationRepositoryImpl {
  final CalculateBurnResuscitation _calculateBurnResuscitation;

  BurnResuscitationRepositoryImpl({
    CalculateBurnResuscitation? calculateBurnResuscitation,
  }) : _calculateBurnResuscitation =
            calculateBurnResuscitation ?? CalculateBurnResuscitation();

  /// Calculates burn fluid resuscitation using Parkland formula
  BurnResuscitationResult calculate({
    required int ageYears,
    required double weightKg,
    required double tbsaPercent,
    required int timeSinceBurnHours,
    required bool hasInhalationInjury,
    required bool hasUrineOutputAvailable,
  }) {
    return _calculateBurnResuscitation.execute(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasUrineOutputAvailable: hasUrineOutputAvailable,
    );
  }
}
