import 'package:chemical_app/features/electrolytes/magnesium/domain/entities/magnesium_correction_result.dart';
import 'package:chemical_app/features/electrolytes/magnesium/domain/use_cases/calculate_magnesium_correction.dart';

/// Repository implementation for magnesium correction
class MagnesiumRepositoryImpl {
  final CalculateMagnesiumCorrection _calculateMagnesiumCorrection;

  MagnesiumRepositoryImpl({
    CalculateMagnesiumCorrection? calculateMagnesiumCorrection,
  }) : _calculateMagnesiumCorrection =
            calculateMagnesiumCorrection ?? CalculateMagnesiumCorrection();

  /// Calculates magnesium correction
  MagnesiumCorrectionResult calculate({
    required double currentMg,
    required bool isSymptomatic,
  }) {
    return _calculateMagnesiumCorrection.execute(
      currentMg: currentMg,
      isSymptomatic: isSymptomatic,
    );
  }
}

