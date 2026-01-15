import 'package:chemical_app/features/insulin_dosing/domain/entities/pregnant_insulin_result.dart';
import 'package:chemical_app/features/insulin_dosing/domain/use_cases/calculate_pregnant_insulin.dart';

/// Repository implementation for pregnant insulin dosing calculations
class PregnantInsulinRepositoryImpl {
  final CalculatePregnantInsulin _calculatePregnantInsulin;

  PregnantInsulinRepositoryImpl({
    CalculatePregnantInsulin? calculatePregnantInsulin,
  }) : _calculatePregnantInsulin =
            calculatePregnantInsulin ?? CalculatePregnantInsulin();

  /// Calculates insulin dosing for pregnant women
  PregnantInsulinResult calculate({
    required double maternalWeightKg,
    required String trimester,
    required String obesityClass,
    required String currentRegimen,
    required Set<String> glucosePatterns,
  }) {
    return _calculatePregnantInsulin.execute(
      maternalWeightKg: maternalWeightKg,
      trimester: trimester,
      obesityClass: obesityClass,
      currentRegimen: currentRegimen,
      glucosePatterns: glucosePatterns,
    );
  }
}
