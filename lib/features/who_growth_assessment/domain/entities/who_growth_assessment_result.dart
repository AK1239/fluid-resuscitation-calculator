/// Entity representing WHO growth assessment result
class WhoGrowthAssessmentResult {
  final int ageMonths;
  final bool isMale;
  final double weightKg;
  final double heightCm;
  final double waz; // Weight-for-Age Z-score
  final double haz; // Height-for-Age Z-score
  final double whz; // Weight-for-Height Z-score

  final WeightForAgeClassification wazClassification;
  final HeightForAgeClassification hazClassification;
  final WeightForHeightClassification whzClassification;
  final OverallNutritionClassification overallClassification;
  final String clinicalInterpretation;
  final String actionRecommendation;

  const WhoGrowthAssessmentResult({
    required this.ageMonths,
    required this.isMale,
    required this.weightKg,
    required this.heightCm,
    required this.waz,
    required this.haz,
    required this.whz,
    required this.wazClassification,
    required this.hazClassification,
    required this.whzClassification,
    required this.overallClassification,
    required this.clinicalInterpretation,
    required this.actionRecommendation,
  });
}

/// Weight-for-Age classification
enum WeightForAgeClassification {
  normal('Normal weight for age'),
  moderateUnderweight('Moderate underweight'),
  severeUnderweight('Severe underweight');

  final String label;
  const WeightForAgeClassification(this.label);
}

/// Height-for-Age classification
enum HeightForAgeClassification {
  normal('Normal height for age'),
  moderateStunting('Moderate stunting'),
  severeStunting('Severe stunting');

  final String label;
  const HeightForAgeClassification(this.label);
}

/// Weight-for-Height classification
enum WeightForHeightClassification {
  normal('Normal weight for height'),
  moderateWasting('Moderate wasting (MAM)'),
  severeWasting('Severe wasting (SAM)');

  final String label;
  const WeightForHeightClassification(this.label);
}

/// Overall nutritional classification
enum OverallNutritionClassification {
  normalGrowth('Normal growth'),
  acuteMalnutrition('Acute malnutrition'),
  chronicMalnutrition('Chronic malnutrition'),
  mixedMalnutrition('Mixed malnutrition');

  final String label;
  const OverallNutritionClassification(this.label);
}
