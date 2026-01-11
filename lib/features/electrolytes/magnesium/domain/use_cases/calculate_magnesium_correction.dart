import 'package:chemical_app/features/electrolytes/magnesium/domain/entities/magnesium_correction_result.dart';

/// Use case for calculating magnesium correction (rule-based)
class CalculateMagnesiumCorrection {
  /// Calculates magnesium correction based on current level and symptoms
  MagnesiumCorrectionResult execute({
    required double currentMg,
    required bool isSymptomatic,
  }) {
    String suggestedDosing;
    String expectedSerumRise;
    String monitoringReminders;

    if (isSymptomatic) {
      // Symptomatic hypomagnesemia - more aggressive correction
      suggestedDosing = '''
Symptomatic hypomagnesemia:
- IV Magnesium sulfate: 1-2 g (8-16 mEq) over 5-10 minutes
- Follow with: 4-6 g (32-48 mEq) over 6-12 hours
- Then: 1-2 g (8-16 mEq) every 6-12 hours until normalized
''';
      expectedSerumRise = 'Expected rise: 0.2-0.4 mg/dL per gram administered';
      monitoringReminders = '''
Monitoring:
- Check serum Mg+2 every 6-12 hours
- Monitor for hypermagnesemia (especially in renal failure)
- Monitor deep tendon reflexes
- Monitor ECG for QT prolongation
- Monitor renal function
''';
    } else {
      // Asymptomatic - slower correction
      if (currentMg < 1.0) {
        suggestedDosing = '''
Severe asymptomatic hypomagnesemia (<1.0 mg/dL):
- IV Magnesium sulfate: 2-4 g (16-32 mEq) over 4-6 hours
- Then: 1-2 g (8-16 mEq) every 6-12 hours
''';
      } else if (currentMg < 1.5) {
        suggestedDosing = '''
Moderate hypomagnesemia (1.0-1.5 mg/dL):
- IV Magnesium sulfate: 1-2 g (8-16 mEq) over 2-4 hours
- Then: 0.5-1 g (4-8 mEq) every 6-12 hours
''';
      } else {
        suggestedDosing = '''
Mild hypomagnesemia (1.5-1.7 mg/dL):
- Oral supplementation: 400-800 mg elemental Mg daily
- Or IV: 1 g (8 mEq) over 2-4 hours if oral not tolerated
''';
      }
      expectedSerumRise = 'Expected rise: 0.1-0.2 mg/dL per gram administered';
      monitoringReminders = '''
Monitoring:
- Check serum Mg+2 every 12-24 hours
- Monitor renal function
- Consider oral supplementation once levels improve
''';
    }

    return MagnesiumCorrectionResult(
      suggestedDosing: suggestedDosing,
      expectedSerumRise: expectedSerumRise,
      monitoringReminders: monitoringReminders,
    );
  }
}

