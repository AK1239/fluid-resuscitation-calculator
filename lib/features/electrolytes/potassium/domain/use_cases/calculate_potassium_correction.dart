import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/electrolytes/potassium/domain/entities/potassium_correction_result.dart';

/// Use case for calculating potassium correction
class CalculatePotassiumCorrection {
  /// Calculates potassium correction using 1.5× deficit rule
  PotassiumCorrectionResult execute({
    required double weightKg,
    required double currentK,
    required double targetK,
  }) {
    // Calculate potassium required using 1.5× deficit rule
    final potassiumRequiredMMol = calculatePotassiumCorrection(
      weightKg: weightKg,
      currentK: currentK,
      targetK: targetK,
    );

    // Calculate approximate number of Slow-K tablets
    final slowKTablets = calculateSlowKTablets(potassiumRequiredMMol);

    // IV guidance (static text as per PRD)
    final ivGuidance = '''
Oral vs IV Guidance:
- Oral: Preferred if patient can tolerate (Slow-K tablets)
- IV: Use if oral not possible or severe hypokalemia
- IV rate: Typically 10-20 mEq/hr (max 40 mEq/hr with cardiac monitoring)
- Dilute in NS or D5W
- Monitor ECG and serum K+ levels
- Avoid rapid correction to prevent hyperkalemia
''';

    return PotassiumCorrectionResult(
      potassiumRequiredMMol: potassiumRequiredMMol,
      slowKTablets: slowKTablets,
      ivGuidance: ivGuidance,
    );
  }
}

