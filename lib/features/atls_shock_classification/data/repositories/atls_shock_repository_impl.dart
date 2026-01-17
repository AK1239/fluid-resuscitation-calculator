import 'package:chemical_app/features/atls_shock_classification/domain/entities/atls_shock_result.dart';
import 'package:chemical_app/features/atls_shock_classification/domain/use_cases/calculate_atls_shock_classification.dart';

/// Repository implementation for ATLS shock classification
class AtlsShockRepositoryImpl {
  final CalculateAtlsShockClassification _calculateAtlsShockClassification;

  AtlsShockRepositoryImpl({
    CalculateAtlsShockClassification? calculateAtlsShockClassification,
  }) : _calculateAtlsShockClassification =
            calculateAtlsShockClassification ??
            CalculateAtlsShockClassification();

  /// Classifies ATLS hemorrhagic shock
  AtlsShockResult classify({
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
    return _calculateAtlsShockClassification.execute(
      age: age,
      weightKg: weightKg,
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      heartRate: heartRate,
      respiratoryRate: respiratoryRate,
      totalUrineVolume: totalUrineVolume,
      timeSinceCatheterHours: timeSinceCatheterHours,
      mentalStatus: mentalStatus,
      baseDeficit: baseDeficit,
      estimatedBloodLossPercent: estimatedBloodLossPercent,
      estimatedBloodLossMl: estimatedBloodLossMl,
    );
  }
}
