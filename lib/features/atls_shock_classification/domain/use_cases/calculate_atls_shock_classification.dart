import 'package:chemical_app/features/atls_shock_classification/domain/entities/atls_shock_result.dart';

/// Use case for calculating ATLS hemorrhagic shock classification
class CalculateAtlsShockClassification {
  /// Calculates pulse pressure
  /// Formula: PP = SBP - DBP
  double _calculatePulsePressure(double systolicBp, double diastolicBp) {
    return systolicBp - diastolicBp;
  }

  /// Calculates urine output in mL/hr
  /// Formula: Urine output = total volume / time (hours)
  double? _calculateUrineOutput(double? totalVolume, double? timeHours) {
    if (totalVolume == null || timeHours == null || timeHours <= 0) {
      return null;
    }
    return totalVolume / timeHours;
  }

  /// Classifies based on heart rate
  AtlsShockClass? _classifyByHeartRate(int? heartRate) {
    if (heartRate == null) return null;
    if (heartRate < 100) return AtlsShockClass.class1;
    if (heartRate <= 120) return AtlsShockClass.class2;
    if (heartRate <= 140) return AtlsShockClass.class3;
    return AtlsShockClass.class4;
  }

  /// Classifies based on systolic BP
  AtlsShockClass? _classifyBySystolicBp(double systolicBp) {
    // ATLS: Normal for Class I/II, Decreased for Class III/IV
    // Using threshold: <90 mmHg is typically considered decreased
    // But ATLS uses "Normal" vs "Decreased" - we'll use a more conservative threshold
    // Normal: ≥100 mmHg, Decreased: <100 mmHg
    if (systolicBp >= 100) {
      // Could be Class I or II (both have "Normal")
      // We can't distinguish between I and II based on BP alone
      return null; // Will be determined by other parameters
    } else {
      // Decreased - could be Class III or IV
      // Use a threshold: <70 is more severe
      if (systolicBp < 70) {
        return AtlsShockClass.class4;
      }
      return AtlsShockClass.class3;
    }
  }

  /// Classifies based on pulse pressure
  AtlsShockClass? _classifyByPulsePressure(double pulsePressure) {
    // Normal/Increased: >40 mmHg (Class I)
    // Decreased: ≤40 mmHg (Class II-IV)
    if (pulsePressure > 40) {
      return AtlsShockClass.class1;
    } else if (pulsePressure > 30) {
      return AtlsShockClass.class2;
    } else if (pulsePressure > 20) {
      return AtlsShockClass.class3;
    } else {
      return AtlsShockClass.class4;
    }
  }

  /// Classifies based on respiratory rate
  AtlsShockClass? _classifyByRespiratoryRate(int respiratoryRate) {
    if (respiratoryRate <= 20) return AtlsShockClass.class1;
    if (respiratoryRate <= 29) return AtlsShockClass.class2;
    if (respiratoryRate <= 35) return AtlsShockClass.class3;
    return AtlsShockClass.class4;
  }

  /// Classifies based on urine output
  AtlsShockClass? _classifyByUrineOutput(double? urineOutputMlPerHr) {
    if (urineOutputMlPerHr == null) return null;
    if (urineOutputMlPerHr > 30) return AtlsShockClass.class1;
    if (urineOutputMlPerHr >= 20) return AtlsShockClass.class2;
    if (urineOutputMlPerHr >= 5) return AtlsShockClass.class3;
    return AtlsShockClass.class4; // Negligible/Anuria
  }

  /// Classifies based on mental status
  AtlsShockClass? _classifyByMentalStatus(MentalStatus mentalStatus) {
    switch (mentalStatus) {
      case MentalStatus.normal:
      case MentalStatus.slightlyAnxious:
        return AtlsShockClass.class1;
      case MentalStatus.mildlyAnxious:
        return AtlsShockClass.class2;
      case MentalStatus.anxiousConfused:
        return AtlsShockClass.class3;
      case MentalStatus.confusedLethargic:
        return AtlsShockClass.class4;
    }
  }

  /// Classifies based on base deficit
  AtlsShockClass? _classifyByBaseDeficit(double? baseDeficit) {
    if (baseDeficit == null) return null;
    if (baseDeficit <= 2.0) return AtlsShockClass.class1;
    if (baseDeficit <= 6.0) return AtlsShockClass.class2;
    if (baseDeficit <= 10.0) return AtlsShockClass.class3;
    return AtlsShockClass.class4;
  }

  /// Classifies based on estimated blood loss percentage
  AtlsShockClass? _classifyByBloodLossPercent(double? bloodLossPercent) {
    if (bloodLossPercent == null) return null;
    if (bloodLossPercent < 15) return AtlsShockClass.class1;
    if (bloodLossPercent <= 30) return AtlsShockClass.class2;
    if (bloodLossPercent <= 40) return AtlsShockClass.class3;
    return AtlsShockClass.class4;
  }

  /// Classifies based on estimated blood loss volume (for 70 kg patient)
  AtlsShockClass? _classifyByBloodLossMl(double? bloodLossMl) {
    if (bloodLossMl == null) return null;
    if (bloodLossMl < 750) return AtlsShockClass.class1;
    if (bloodLossMl <= 1500) return AtlsShockClass.class2;
    if (bloodLossMl <= 2000) return AtlsShockClass.class3;
    return AtlsShockClass.class4;
  }

  /// Generates physiologic interpretation
  String _generatePhysiologicInterpretation(
    AtlsShockClass shockClass,
    double pulsePressure,
    double? urineOutput,
    double systolicBp,
    int respiratoryRate,
  ) {
    final interpretations = <String>[];

    if (pulsePressure <= 40) {
      interpretations.add('Narrowed pulse pressure');
    }
    if (urineOutput != null && urineOutput < 30) {
      interpretations.add('oliguria');
    }
    if (systolicBp < 100) {
      interpretations.add('decreased systolic BP');
    }
    if (respiratoryRate > 20) {
      interpretations.add('tachypnea');
    }

    if (interpretations.isEmpty) {
      final classNum = shockClass.name.substring(5);
      return 'Physiologic parameters within normal limits for Class $classNum.';
    }

    final interpretation = interpretations.join(' + ');
    return '$interpretation indicates reduced circulating volume and impaired tissue perfusion.';
  }

  /// Executes the classification
  /// Uses the highest (most severe) class when parameters indicate different classes
  AtlsShockResult execute({
    int? age,
    double? weightKg,
    required double systolicBp,
    required double diastolicBp,
    int? heartRate,
    required int respiratoryRate,
    double? totalUrineVolume,
    double? timeSinceCatheterHours,
    required MentalStatus mentalStatus,
    double? baseDeficit,
    double? estimatedBloodLossPercent,
    double? estimatedBloodLossMl,
  }) {
    // Use default weight if not provided
    final weight = weightKg ?? 70.0;

    // Calculate derived parameters
    final pulsePressure = _calculatePulsePressure(systolicBp, diastolicBp);
    final urineOutput = _calculateUrineOutput(
      totalUrineVolume,
      timeSinceCatheterHours,
    );

    // Classify by each available parameter
    final classifications = <AtlsShockClass>[];
    final escalationParameters = <String>[];

    // Heart rate (if available)
    final hrClass = _classifyByHeartRate(heartRate);
    if (hrClass != null && heartRate != null) {
      classifications.add(hrClass);
      final classNum = hrClass.name.substring(5);
      escalationParameters.add('Heart rate: $heartRate bpm → Class $classNum');
    }

    // Systolic BP
    final sbpClass = _classifyBySystolicBp(systolicBp);
    if (sbpClass != null) {
      classifications.add(sbpClass);
      escalationParameters.add(
        'Systolic BP: ${systolicBp.toStringAsFixed(0)} mmHg → Class ${sbpClass.name.substring(5)}',
      );
    }

    // Pulse pressure
    final ppClass = _classifyByPulsePressure(pulsePressure);
    if (ppClass != null) {
      classifications.add(ppClass);
      escalationParameters.add(
        'Pulse pressure: ${pulsePressure.toStringAsFixed(0)} mmHg → Class ${ppClass.name.substring(5)}',
      );
    }

    // Respiratory rate
    final rrClass = _classifyByRespiratoryRate(respiratoryRate);
    if (rrClass != null) {
      classifications.add(rrClass);
      escalationParameters.add(
        'Respiratory rate: $respiratoryRate/min → Class ${rrClass.name.substring(5)}',
      );
    }

    // Urine output
    final uoClass = _classifyByUrineOutput(urineOutput);
    if (uoClass != null) {
      classifications.add(uoClass);
      final uoStr = urineOutput != null
          ? urineOutput.toStringAsFixed(1)
          : 'N/A';
      escalationParameters.add(
        'Urine output: $uoStr mL/hr → Class ${uoClass.name.substring(5)}',
      );
    }

    // Mental status
    final msClass = _classifyByMentalStatus(mentalStatus);
    if (msClass != null) {
      classifications.add(msClass);
      escalationParameters.add(
        'Mental status → Class ${msClass.name.substring(5)}',
      );
    }

    // Base deficit
    final bdClass = _classifyByBaseDeficit(baseDeficit);
    if (bdClass != null && baseDeficit != null) {
      classifications.add(bdClass);
      escalationParameters.add(
        'Base deficit: ${baseDeficit.toStringAsFixed(1)} mmol/L → Class ${bdClass.name.substring(5)}',
      );
    }

    // Estimated blood loss (physiologic parameters override if discordant)
    // Only use if no other parameters available or as supporting evidence
    if (classifications.isEmpty) {
      final blPercentClass = _classifyByBloodLossPercent(
        estimatedBloodLossPercent,
      );
      if (blPercentClass != null && estimatedBloodLossPercent != null) {
        classifications.add(blPercentClass);
        escalationParameters.add(
          'Blood loss: ${estimatedBloodLossPercent.toStringAsFixed(1)}% TBV → Class ${blPercentClass.name.substring(5)}',
        );
      } else {
        final blMlClass = _classifyByBloodLossMl(estimatedBloodLossMl);
        if (blMlClass != null && estimatedBloodLossMl != null) {
          classifications.add(blMlClass);
          escalationParameters.add(
            'Blood loss: ${estimatedBloodLossMl.toStringAsFixed(0)} mL → Class ${blMlClass.name.substring(5)}',
          );
        }
      }
    }

    // Select the highest (most severe) class
    AtlsShockClass finalClass;
    if (classifications.isEmpty) {
      // Default to Class I if no parameters available
      finalClass = AtlsShockClass.class1;
    } else {
      // Find the most severe class (highest number)
      finalClass = classifications.reduce((a, b) {
        final aValue = a.index;
        final bValue = b.index;
        return aValue > bValue ? a : b;
      });
    }

    // Generate physiologic interpretation
    final interpretation = _generatePhysiologicInterpretation(
      finalClass,
      pulsePressure,
      urineOutput,
      systolicBp,
      respiratoryRate,
    );

    return AtlsShockResult(
      age: age,
      weightKg: weight,
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      pulsePressure: pulsePressure,
      respiratoryRate: respiratoryRate,
      totalUrineVolume: totalUrineVolume,
      timeSinceCatheterHours: timeSinceCatheterHours,
      urineOutputMlPerHr: urineOutput,
      mentalStatus: mentalStatus,
      baseDeficit: baseDeficit,
      estimatedBloodLossPercent: estimatedBloodLossPercent,
      estimatedBloodLossMl: estimatedBloodLossMl,
      shockClass: finalClass,
      parametersThatDroveEscalation: escalationParameters,
      physiologicInterpretation: interpretation,
    );
  }
}
