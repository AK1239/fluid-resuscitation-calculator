import 'dart:math' as math;
import 'package:chemical_app/features/egfr_calculator/domain/entities/egfr_result.dart';

/// Use case for calculating eGFR using CKD-EPI equations
class CalculateEgfr {
  /// Converts serum creatinine from μmol/L to mg/dL
  /// Conversion factor: 1 mg/dL = 88.4 μmol/L
  double _convertCreatinineToMgPerDl(double creatinineUmolPerL) {
    return creatinineUmolPerL / 88.4;
  }

  /// Calculates eGFR using CKD-EPI 2021 creatinine-only equation
  /// For males: eGFR = 142 × min(Cr/0.9, 1)^(-0.302) × max(Cr/0.9, 1)^(-1.200) × 0.9938^Age
  /// For females: eGFR = 142 × min(Cr/0.7, 1)^(-0.241) × max(Cr/0.7, 1)^(-1.200) × 0.9938^Age
  double _calculateCreatinineOnlyEgfr({
    required double creatinineMgPerDl,
    required int age,
    required bool isMale,
  }) {
    final kappa = isMale ? 0.9 : 0.7;
    final alpha = isMale ? -0.302 : -0.241;

    final crOverKappa = creatinineMgPerDl / kappa;
    final minTerm = math.min(crOverKappa, 1.0);
    final maxTerm = math.max(crOverKappa, 1.0);

    final egfr =
        142.0 *
        math.pow(minTerm, alpha) *
        math.pow(maxTerm, -1.200) *
        math.pow(0.9938, age);

    return egfr;
  }

  /// Calculates eGFR using CKD-EPI 2012 combined creatinine + cystatin C equation (most accurate)
  /// eGFR = 135 × min(Cr/κ, 1)^α × max(Cr/κ, 1)^(-0.601) × min(CysC/0.8, 1)^(-0.375) × max(CysC/0.8, 1)^(-0.711) × 0.995^Age × SexFactor
  /// Male: κ = 0.9, α = -0.302, SexFactor = 1
  /// Female: κ = 0.7, α = -0.241, SexFactor = 0.969
  double _calculateCombinedEgfr({
    required double creatinineMgPerDl,
    required double cystatinC,
    required int age,
    required bool isMale,
  }) {
    final kappa = isMale ? 0.9 : 0.7;
    final alpha = isMale ? -0.302 : -0.241;
    final sexFactor = isMale ? 1.0 : 0.969;

    final crOverKappa = creatinineMgPerDl / kappa;
    final minCrTerm = math.min(crOverKappa, 1.0);
    final maxCrTerm = math.max(crOverKappa, 1.0);

    final cysCOver08 = cystatinC / 0.8;
    final minCysCTerm = math.min(cysCOver08, 1.0);
    final maxCysCTerm = math.max(cysCOver08, 1.0);

    final egfr =
        135.0 *
        math.pow(minCrTerm, alpha) *
        math.pow(maxCrTerm, -0.601) *
        math.pow(minCysCTerm, -0.375) *
        math.pow(maxCysCTerm, -0.711) *
        math.pow(0.995, age) *
        sexFactor;

    return egfr;
  }

  /// Determines CKD stage based on eGFR (KDIGO 2023)
  CkdStage _determineCkdStage(double egfr) {
    if (egfr >= 90) {
      return CkdStage.g1;
    } else if (egfr >= 60) {
      return CkdStage.g2;
    } else if (egfr >= 45) {
      return CkdStage.g3a;
    } else if (egfr >= 30) {
      return CkdStage.g3b;
    } else if (egfr >= 15) {
      return CkdStage.g4;
    } else {
      return CkdStage.g5;
    }
  }

  /// Executes the calculation
  /// Automatically selects the most accurate formula based on available inputs
  EgfrResult execute({
    required double serumCreatinineUmolPerL,
    double? cystatinC,
    required int age,
    required bool isMale,
  }) {
    // Convert creatinine to mg/dL
    final serumCreatinineMgPerDl = _convertCreatinineToMgPerDl(
      serumCreatinineUmolPerL,
    );

    double egfr;
    EgfrFormulaType formulaUsed;

    // Determine which formula to use
    if (cystatinC != null && cystatinC > 0) {
      // Both creatinine and cystatin C available - use combined formula (most accurate)
      egfr = _calculateCombinedEgfr(
        creatinineMgPerDl: serumCreatinineMgPerDl,
        cystatinC: cystatinC,
        age: age,
        isMale: isMale,
      );
      formulaUsed = EgfrFormulaType.combined;
    } else {
      // Only creatinine available - use CKD-EPI 2021
      egfr = _calculateCreatinineOnlyEgfr(
        creatinineMgPerDl: serumCreatinineMgPerDl,
        age: age,
        isMale: isMale,
      );
      formulaUsed = EgfrFormulaType.creatinineOnly;
    }

    // Round to 1 decimal place
    final roundedEgfr = (egfr * 10).roundToDouble() / 10;

    // Determine CKD stage
    final ckdStage = _determineCkdStage(roundedEgfr);

    return EgfrResult(
      serumCreatinine: serumCreatinineUmolPerL,
      cystatinC: cystatinC,
      age: age,
      isMale: isMale,
      serumCreatinineMgPerDl: serumCreatinineMgPerDl,
      formulaUsed: formulaUsed,
      egfr: roundedEgfr,
      ckdStage: ckdStage,
    );
  }
}
