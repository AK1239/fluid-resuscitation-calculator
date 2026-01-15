import 'package:chemical_app/features/norepinephrine/domain/entities/norepinephrine_result.dart';
import 'package:chemical_app/features/norepinephrine/domain/use_cases/calculate_norepinephrine.dart';

/// Repository implementation for norepinephrine infusion calculation
class NorepinephrineRepositoryImpl {
  final CalculateNorepinephrine _calculateNorepinephrine;

  NorepinephrineRepositoryImpl({
    CalculateNorepinephrine? calculateNorepinephrine,
  }) : _calculateNorepinephrine =
            calculateNorepinephrine ?? CalculateNorepinephrine();

  /// Calculates norepinephrine infusion rate
  NorepinephrineResult calculate({
    required double weightKg,
    required double doseUgPerKgPerMin,
  }) {
    return _calculateNorepinephrine.execute(
      weightKg: weightKg,
      doseUgPerKgPerMin: doseUgPerKgPerMin,
    );
  }
}
