import 'package:chemical_app/features/premature_baby_fluid/domain/entities/premature_baby_fluid_result.dart';
import 'package:chemical_app/features/premature_baby_fluid/domain/use_cases/calculate_premature_baby_fluid.dart';

/// Repository implementation for premature baby fluid calculation
class PrematureBabyFluidRepositoryImpl {
  final CalculatePrematureBabyFluid _calculatePrematureBabyFluid;

  PrematureBabyFluidRepositoryImpl({
    CalculatePrematureBabyFluid? calculatePrematureBabyFluid,
  }) : _calculatePrematureBabyFluid =
            calculatePrematureBabyFluid ?? CalculatePrematureBabyFluid();

  /// Calculates premature baby fluid requirements
  PrematureBabyFluidResult calculate({
    required GestationalCategory gestationalCategory,
    required int dayOfLife,
    required double currentWeightKg,
    required bool canTakeEbm,
    required Environment environment,
    required bool hasSevereHie,
    required bool hasAki,
    required bool hasCerebralEdema,
    required bool hasMultiOrganDamage,
  }) {
    return _calculatePrematureBabyFluid.execute(
      gestationalCategory: gestationalCategory,
      dayOfLife: dayOfLife,
      currentWeightKg: currentWeightKg,
      canTakeEbm: canTakeEbm,
      environment: environment,
      hasSevereHie: hasSevereHie,
      hasAki: hasAki,
      hasCerebralEdema: hasCerebralEdema,
      hasMultiOrganDamage: hasMultiOrganDamage,
    );
  }
}