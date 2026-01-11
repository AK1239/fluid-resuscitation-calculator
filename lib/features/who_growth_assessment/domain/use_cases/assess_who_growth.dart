import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_assessment_result.dart';

/// Use case for WHO growth assessment
class AssessWhoGrowth {
  /// Assesses child growth using WHO Z-scores
  WhoGrowthAssessmentResult execute({
    required int ageMonths,
    required bool isMale,
    required double weightKg,
    required double heightCm,
    required double waz,
    required double haz,
    required double whz,
  }) {
    // Classify each Z-score
    final wazClassification = _classifyWeightForAge(waz);
    final hazClassification = _classifyHeightForAge(haz);
    final whzClassification = _classifyWeightForHeight(whz);

    // Determine overall classification
    final overallClassification = _determineOverallClassification(
      wazClassification,
      hazClassification,
      whzClassification,
    );

    // Generate clinical interpretation
    final clinicalInterpretation = _generateClinicalInterpretation(
      wazClassification,
      hazClassification,
      whzClassification,
    );

    // Generate action recommendation
    final actionRecommendation = _generateActionRecommendation(
      wazClassification,
      hazClassification,
      whzClassification,
      overallClassification,
    );

    return WhoGrowthAssessmentResult(
      ageMonths: ageMonths,
      isMale: isMale,
      weightKg: weightKg,
      heightCm: heightCm,
      waz: waz,
      haz: haz,
      whz: whz,
      wazClassification: wazClassification,
      hazClassification: hazClassification,
      whzClassification: whzClassification,
      overallClassification: overallClassification,
      clinicalInterpretation: clinicalInterpretation,
      actionRecommendation: actionRecommendation,
    );
  }

  /// Classifies Weight-for-Age Z-score
  WeightForAgeClassification _classifyWeightForAge(double waz) {
    if (waz >= -2) {
      return WeightForAgeClassification.normal;
    } else if (waz >= -3) {
      return WeightForAgeClassification.moderateUnderweight;
    } else {
      return WeightForAgeClassification.severeUnderweight;
    }
  }

  /// Classifies Height-for-Age Z-score
  HeightForAgeClassification _classifyHeightForAge(double haz) {
    if (haz >= -2) {
      return HeightForAgeClassification.normal;
    } else if (haz >= -3) {
      return HeightForAgeClassification.moderateStunting;
    } else {
      return HeightForAgeClassification.severeStunting;
    }
  }

  /// Classifies Weight-for-Height Z-score
  WeightForHeightClassification _classifyWeightForHeight(double whz) {
    if (whz >= -2) {
      return WeightForHeightClassification.normal;
    } else if (whz >= -3) {
      return WeightForHeightClassification.moderateWasting;
    } else {
      return WeightForHeightClassification.severeWasting;
    }
  }

  /// Determines overall nutritional classification
  OverallNutritionClassification _determineOverallClassification(
    WeightForAgeClassification waz,
    HeightForAgeClassification haz,
    WeightForHeightClassification whz,
  ) {
    final hasAcute = whz != WeightForHeightClassification.normal;
    final hasChronic = haz != HeightForAgeClassification.normal;

    if (!hasAcute && !hasChronic) {
      return OverallNutritionClassification.normalGrowth;
    } else if (hasAcute && !hasChronic) {
      return OverallNutritionClassification.acuteMalnutrition;
    } else if (!hasAcute && hasChronic) {
      return OverallNutritionClassification.chronicMalnutrition;
    } else {
      return OverallNutritionClassification.mixedMalnutrition;
    }
  }

  /// Generates clinical interpretation
  String _generateClinicalInterpretation(
    WeightForAgeClassification waz,
    HeightForAgeClassification haz,
    WeightForHeightClassification whz,
  ) {
    final interpretations = <String>[];

    if (waz != WeightForAgeClassification.normal) {
      interpretations.add(
        'Weight-for-age is ${waz.label.toLowerCase()}. This reflects overall nutritional status.',
      );
    }

    if (haz != HeightForAgeClassification.normal) {
      interpretations.add(
        'Height-for-age is ${haz.label.toLowerCase()}. This indicates chronic malnutrition (stunting), suggesting long-term nutritional deficiencies.',
      );
    }

    if (whz != WeightForHeightClassification.normal) {
      interpretations.add(
        'Weight-for-height is ${whz.label.toLowerCase()}. This indicates acute malnutrition (wasting), suggesting recent weight loss or inadequate nutrition.',
      );
    }

    if (interpretations.isEmpty) {
      return 'All anthropometric indicators are within normal limits. The child shows normal growth patterns.';
    }

    return interpretations.join('\n\n');
  }

  /// Generates action recommendation
  String _generateActionRecommendation(
    WeightForAgeClassification waz,
    HeightForAgeClassification haz,
    WeightForHeightClassification whz,
    OverallNutritionClassification overall,
  ) {
    // Check for severe conditions first
    final hasSevereWasting = whz == WeightForHeightClassification.severeWasting;
    final hasSevereStunting = haz == HeightForAgeClassification.severeStunting;
    final hasSevereUnderweight = waz == WeightForAgeClassification.severeUnderweight;

    if (hasSevereWasting || hasSevereUnderweight) {
      return 'URGENT REFERRAL: Child has severe acute malnutrition. Requires immediate assessment and treatment at a facility with capacity for management of severe malnutrition.';
    }

    if (hasSevereStunting) {
      return 'Referral for comprehensive assessment: Severe stunting indicates long-term nutritional deficiencies. Consider referral to nutrition specialist for detailed evaluation and management.';
    }

    // Moderate conditions
    final hasModerateWasting = whz == WeightForHeightClassification.moderateWasting;
    final hasModerateStunting = haz == HeightForAgeClassification.moderateStunting;
    final hasModerateUnderweight = waz == WeightForAgeClassification.moderateUnderweight;

    if (hasModerateWasting || hasModerateUnderweight) {
      return 'Outpatient Therapeutic Care: Child requires nutritional rehabilitation. Provide ready-to-use therapeutic food (RUTF) and close monitoring. Arrange follow-up within 1-2 weeks.';
    }

    if (hasModerateStunting) {
      return 'Nutrition counselling and monitoring: Moderate stunting requires dietary counselling, micronutrient supplementation, and regular growth monitoring. Follow-up in 1-2 months.';
    }

    if (overall == OverallNutritionClassification.normalGrowth) {
      return 'Routine follow-up: Continue routine growth monitoring and standard child health services. Provide age-appropriate nutrition education to parents.';
    }

    // Mixed or other conditions
    return 'Comprehensive nutrition assessment and support: Multiple indicators suggest nutritional concerns. Provide nutrition counselling, consider micronutrient supplementation, and arrange regular monitoring. Follow-up within 1 month.';
  }
}
