import 'package:chemical_app/features/urine_output_aki/domain/entities/urine_output_aki_result.dart';

/// Use case for calculating urine output and AKI staging
class CalculateUrineOutputAki {
  /// Calculates urine volume produced
  /// Formula: urine_volume = current_volume - previous_volume
  double _calculateUrineVolume(double currentVolume, double previousVolume) {
    return currentVolume - previousVolume;
  }

  /// Calculates time interval in hours
  double _calculateTimeHours(DateTime currentTime, DateTime previousTime) {
    final difference = currentTime.difference(previousTime);
    // Convert total minutes to hours for accurate calculation
    return difference.inMinutes / 60.0;
  }

  /// Calculates urine output in mL/kg/hr
  /// Formula: urine_output = urine_volume / (weight × time_hours)
  double _calculateUrineOutput(
    double urineVolume,
    double weightKg,
    double timeHours,
  ) {
    if (weightKg <= 0 || timeHours <= 0) {
      return 0.0;
    }
    return urineVolume / (weightKg * timeHours);
  }

  /// Determines urine output interpretation
  UrineOutputInterpretation _interpretUrineOutput(double urineOutput) {
    if (urineOutput < 0.5) {
      return UrineOutputInterpretation.oliguria;
    } else if (urineOutput >= 0.5 && urineOutput <= 2.0) {
      return UrineOutputInterpretation.normal;
    } else {
      return UrineOutputInterpretation.polyuria;
    }
  }

  /// Determines AKI stage based on KDIGO urine output criteria
  /// Stage 1: < 0.5 mL/kg/hr for 6–12 hours
  /// Stage 2: < 0.5 mL/kg/hr for ≥ 12 hours
  /// Stage 3: < 0.3 mL/kg/hr for ≥ 24 hours OR anuria (≈0) for ≥ 12 hours
  AkiStage _determineAkiStage(double urineOutput, double timeHours) {
    // If urine output is normal (≥ 0.5), no AKI
    if (urineOutput >= 0.5) {
      return AkiStage.noAki;
    }

    // Check for anuria (≈0 mL/kg/hr) for ≥ 12 hours → Stage 3
    if (urineOutput < 0.01 && timeHours >= 12) {
      return AkiStage.stage3;
    }

    // Check for < 0.3 mL/kg/hr for ≥ 24 hours → Stage 3
    if (urineOutput < 0.3 && timeHours >= 24) {
      return AkiStage.stage3;
    }

    // Check for < 0.5 mL/kg/hr for ≥ 12 hours → Stage 2
    if (urineOutput < 0.5 && timeHours >= 12) {
      return AkiStage.stage2;
    }

    // Check for < 0.5 mL/kg/hr for 6–12 hours → Stage 1
    if (urineOutput < 0.5 && timeHours >= 6 && timeHours < 12) {
      return AkiStage.stage1;
    }

    // If duration < 6 hours, no AKI yet (insufficient duration)
    return AkiStage.noAki;
  }

  /// Gets clinical message based on AKI stage
  String _getClinicalMessage(AkiStage akiStage) {
    switch (akiStage) {
      case AkiStage.noAki:
        return 'Continue monitoring';
      case AkiStage.stage1:
        return 'Monitor closely';
      case AkiStage.stage2:
        return 'High risk – urgent evaluation';
      case AkiStage.stage3:
        return 'Critical – nephrology consult indicated';
    }
  }

  /// Executes the calculation
  /// Throws exception if validation fails
  UrineOutputAkiResult execute({
    required double currentVolume,
    required double previousVolume,
    required DateTime currentTime,
    required DateTime previousTime,
    required double weightKg,
  }) {
    // Validation
    final timeHours = _calculateTimeHours(currentTime, previousTime);
    if (timeHours <= 0) {
      throw ArgumentError('Invalid time interval: time must be in the future');
    }

    if (weightKg <= 0) {
      throw ArgumentError('Invalid weight: weight must be greater than 0');
    }

    final urineVolume = _calculateUrineVolume(currentVolume, previousVolume);
    if (urineVolume < 0) {
      throw ArgumentError(
        'Invalid volume: current volume must be ≥ previous volume',
      );
    }

    // Calculate urine output
    final urineOutput = _calculateUrineOutput(urineVolume, weightKg, timeHours);

    // Round to 2 decimal places
    final roundedUrineOutput = (urineOutput * 100).roundToDouble() / 100;

    // Interpret results
    final interpretation = _interpretUrineOutput(roundedUrineOutput);
    final akiStage = _determineAkiStage(roundedUrineOutput, timeHours);
    final clinicalMessage = _getClinicalMessage(akiStage);

    return UrineOutputAkiResult(
      currentVolume: currentVolume,
      previousVolume: previousVolume,
      urineVolume: urineVolume,
      timeHours: timeHours,
      weightKg: weightKg,
      urineOutputMlPerKgPerHr: roundedUrineOutput,
      urineOutputInterpretation: interpretation,
      akiStage: akiStage,
      clinicalMessage: clinicalMessage,
    );
  }
}
