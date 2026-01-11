import 'package:chemical_app/features/electrolytes/calcium/domain/entities/calcium_correction_result.dart';

/// Use case for calculating calcium correction (rule-based)
class CalculateCalciumCorrection {
  /// Calculates calcium correction based on weight, current level, and symptoms
  CalciumCorrectionResult execute({
    required double weightKg,
    required double currentCa,
    required bool isSymptomatic,
  }) {
    // Estimate calcium deficit
    // Formula: (2.6 - currentCa) × weight × 0.3
    // This is a simplified estimation
    // Normal calcium level: 2.1-2.6 mmol/L (target: 2.6 mmol/L)
    final targetCa = 2.6; // Normal calcium level in mmol/L
    final estimatedDeficit = (targetCa - currentCa) * weightKg * 0.3;

    String ivGuidance;
    String oralSupplementation;

    if (isSymptomatic) {
      // Symptomatic hypocalcemia - urgent correction
      ivGuidance = '''
Symptomatic hypocalcemia - Urgent correction:
- IV Calcium gluconate: 1-2 g (90-180 mg elemental Ca) over 10-20 minutes
- Follow with: 1-3 g (90-270 mg elemental Ca) in 1 L D5W or NS over 4-6 hours
- Then: 0.5-1.5 g (45-135 mg elemental Ca) every 6-8 hours
- Monitor for hypercalcemia
- Consider checking ionized calcium if available
''';
      oralSupplementation = '''
Oral supplementation (after IV correction):
- Calcium carbonate: 1-2 g TID-QID with meals
- Or Calcium citrate: 1-2 g TID-QID (better absorbed, can take without meals)
- Monitor serum calcium levels
''';
    } else {
      // Asymptomatic - slower correction
      if (currentCa < 1.75) {
        ivGuidance = '''
Severe asymptomatic hypocalcemia (<1.75 mmol/L):
- IV Calcium gluconate: 1-2 g (90-180 mg elemental Ca) over 2-4 hours
- Then: 0.5-1 g (45-90 mg elemental Ca) every 6-8 hours
''';
      } else if (currentCa < 2.1) {
        ivGuidance = '''
Moderate hypocalcemia (1.75-2.1 mmol/L):
- IV Calcium gluconate: 1 g (90 mg elemental Ca) over 2-4 hours
- Then: 0.5-1 g (45-90 mg elemental Ca) every 8-12 hours
- Or consider oral supplementation if tolerated
''';
      } else {
        ivGuidance = '''
Mild hypocalcemia (2.1-2.5 mmol/L):
- Oral supplementation preferred
- IV only if oral not tolerated or levels continue to drop
''';
      }
      oralSupplementation = '''
Oral supplementation:
- Calcium carbonate: 1-2 g TID-QID with meals
- Or Calcium citrate: 1-2 g TID-QID
- Take with Vitamin D if deficiency present
- Monitor serum calcium and phosphorus levels
''';
    }

    return CalciumCorrectionResult(
      estimatedDeficit: estimatedDeficit > 0 ? estimatedDeficit : 0,
      ivGuidance: ivGuidance,
      oralSupplementation: oralSupplementation,
    );
  }
}

