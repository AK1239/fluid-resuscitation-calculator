import 'package:chemical_app/features/shock_index/domain/entities/shock_index_result.dart';

/// Use case for calculating Shock Index and TASI
class CalculateShockIndex {
  /// Calculates Shock Index
  /// Formula: SI = HR ÷ SBP
  double _calculateShockIndex(double heartRate, double systolicBp) {
    if (systolicBp <= 0) {
      throw ArgumentError('Systolic BP must be greater than 0');
    }
    return heartRate / systolicBp;
  }

  /// Calculates Trauma-Adjusted Shock Index
  /// Formula: TASI = Age × SI
  double _calculateTasi(double age, double shockIndex) {
    return age * shockIndex;
  }

  /// Determines Shock Index interpretation
  ShockIndexInterpretation _interpretShockIndex(double shockIndex) {
    if (shockIndex < 0.5) {
      return ShockIndexInterpretation.normal;
    } else if (shockIndex >= 0.5 && shockIndex < 0.9) {
      return ShockIndexInterpretation.borderline;
    } else if (shockIndex >= 0.9 && shockIndex < 1.0) {
      return ShockIndexInterpretation.highRisk;
    } else {
      // shockIndex >= 1.0
      return ShockIndexInterpretation.severe;
    }
  }

  /// Determines TASI interpretation
  TraumaAdjustedShockIndexInterpretation _interpretTasi(double tasi) {
    if (tasi < 40) {
      return TraumaAdjustedShockIndexInterpretation.lowRisk;
    } else if (tasi >= 40 && tasi < 80) {
      return TraumaAdjustedShockIndexInterpretation.moderateRisk;
    } else if (tasi >= 80 && tasi < 120) {
      return TraumaAdjustedShockIndexInterpretation.highRisk;
    } else {
      // tasi >= 120
      return TraumaAdjustedShockIndexInterpretation.veryHighRisk;
    }
  }

  /// Executes the calculation
  ShockIndexResult execute({
    required double heartRate,
    required double systolicBp,
    double? age,
  }) {
    // Calculate Shock Index
    final shockIndex = _calculateShockIndex(heartRate, systolicBp);

    // Round to 2 decimal places
    final roundedShockIndex = (shockIndex * 100).roundToDouble() / 100;

    // Interpret SI
    final siInterpretation = _interpretShockIndex(roundedShockIndex);

    // Calculate TASI if age is provided
    double? roundedTasi;
    TraumaAdjustedShockIndexInterpretation? tasiInterpretation;
    if (age != null && age > 0) {
      final tasi = _calculateTasi(age, roundedShockIndex);
      roundedTasi = (tasi * 100).roundToDouble() / 100;
      tasiInterpretation = _interpretTasi(roundedTasi);
    }

    return ShockIndexResult(
      heartRate: heartRate,
      systolicBp: systolicBp,
      age: age,
      shockIndex: roundedShockIndex,
      traumaAdjustedShockIndex: roundedTasi,
      shockIndexInterpretation: siInterpretation,
      tasiInterpretation: tasiInterpretation,
    );
  }
}
