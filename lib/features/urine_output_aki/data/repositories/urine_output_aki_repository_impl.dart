import 'package:chemical_app/features/urine_output_aki/domain/entities/urine_output_aki_result.dart';
import 'package:chemical_app/features/urine_output_aki/domain/use_cases/calculate_urine_output_aki.dart';

/// Repository implementation for urine output and AKI staging calculation
class UrineOutputAkiRepositoryImpl {
  final CalculateUrineOutputAki _calculateUrineOutputAki;

  UrineOutputAkiRepositoryImpl({
    CalculateUrineOutputAki? calculateUrineOutputAki,
  }) : _calculateUrineOutputAki =
           calculateUrineOutputAki ?? CalculateUrineOutputAki();

  /// Calculates urine output and AKI stage
  UrineOutputAkiResult calculate({
    required double currentVolume,
    required double previousVolume,
    required DateTime currentTime,
    required DateTime previousTime,
    required double weightKg,
  }) {
    return _calculateUrineOutputAki.execute(
      currentVolume: currentVolume,
      previousVolume: previousVolume,
      currentTime: currentTime,
      previousTime: previousTime,
      weightKg: weightKg,
    );
  }
}
