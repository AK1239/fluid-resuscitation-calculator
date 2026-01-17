import 'package:chemical_app/features/egfr_calculator/domain/entities/egfr_result.dart';
import 'package:chemical_app/features/egfr_calculator/domain/use_cases/calculate_egfr.dart';

/// Repository implementation for eGFR calculation
class EgfrRepositoryImpl {
  final CalculateEgfr _calculateEgfr;

  EgfrRepositoryImpl({
    CalculateEgfr? calculateEgfr,
  }) : _calculateEgfr = calculateEgfr ?? CalculateEgfr();

  /// Calculates eGFR
  EgfrResult calculate({
    required double serumCreatinineUmolPerL,
    double? cystatinC,
    required int age,
    required bool isMale,
  }) {
    return _calculateEgfr.execute(
      serumCreatinineUmolPerL: serumCreatinineUmolPerL,
      cystatinC: cystatinC,
      age: age,
      isMale: isMale,
    );
  }
}
