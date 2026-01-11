import 'package:chemical_app/features/insulin_dosing/domain/entities/insulin_dosing_result.dart';
import 'package:chemical_app/features/insulin_dosing/domain/use_cases/calculate_insulin_dosing.dart';

/// Repository implementation for insulin dosing
class InsulinDosingRepositoryImpl {
  final CalculateInsulinDosing _calculateInsulinDosing;

  InsulinDosingRepositoryImpl({
    CalculateInsulinDosing? calculateInsulinDosing,
  }) : _calculateInsulinDosing =
            calculateInsulinDosing ?? CalculateInsulinDosing();

  /// Calculates insulin dosing
  InsulinDosingResult calculate({
    required double weightKg,
    double tddFactor = 0.5,
  }) {
    return _calculateInsulinDosing.execute(
      weightKg: weightKg,
      tddFactor: tddFactor,
    );
  }
}
