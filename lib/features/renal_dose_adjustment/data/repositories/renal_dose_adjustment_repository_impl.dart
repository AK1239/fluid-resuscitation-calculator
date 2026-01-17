import 'package:chemical_app/features/renal_dose_adjustment/domain/entities/renal_dose_adjustment_result.dart';
import 'package:chemical_app/features/renal_dose_adjustment/domain/use_cases/calculate_renal_dose_adjustment.dart';

/// Repository implementation for renal dose adjustment calculation
class RenalDoseAdjustmentRepositoryImpl {
  final CalculateRenalDoseAdjustment _calculateRenalDoseAdjustment;

  RenalDoseAdjustmentRepositoryImpl({
    CalculateRenalDoseAdjustment? calculateRenalDoseAdjustment,
  }) : _calculateRenalDoseAdjustment =
            calculateRenalDoseAdjustment ?? CalculateRenalDoseAdjustment();

  /// Calculates renal dose adjustment
  RenalDoseAdjustmentResult calculate({
    required int age,
    required bool isMale,
    required double weightKg,
    required double serumCreatinineUmolPerL,
    required double standardDose,
  }) {
    return _calculateRenalDoseAdjustment.execute(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinineUmolPerL: serumCreatinineUmolPerL,
      standardDose: standardDose,
    );
  }
}
