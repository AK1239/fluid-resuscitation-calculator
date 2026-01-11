import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_assessment_result.dart';

class WhoGrowthResultWidget extends StatelessWidget {
  final WhoGrowthAssessmentResult result;

  const WhoGrowthResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Anthropometric Summary
        ResultCard(
          title: 'Anthropometric Summary',
          child: Column(
            children: [
              ResultRow(
                label: 'Weight-for-Age',
                value: result.wazClassification.label,
                isHighlighted: result.wazClassification !=
                    WeightForAgeClassification.normal,
              ),
              ResultRow(
                label: 'Height-for-Age',
                value: result.hazClassification.label,
                isHighlighted: result.hazClassification !=
                    HeightForAgeClassification.normal,
              ),
              ResultRow(
                label: 'Weight-for-Height',
                value: result.whzClassification.label,
                isHighlighted: result.whzClassification !=
                    WeightForHeightClassification.normal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Overall Nutritional Classification
        ResultCard(
          title: 'Overall Nutritional Classification',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getClassificationColor(context, result.overallClassification)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getClassificationIcon(result.overallClassification),
                  color: _getClassificationColor(
                      context, result.overallClassification),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.overallClassification.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getClassificationColor(
                              context, result.overallClassification),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Clinical Interpretation
        ResultCard(
          title: 'Clinical Interpretation',
          child: Text(
            result.clinicalInterpretation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        // Action Recommendation
        ResultCard(
          title: 'Action Recommendation',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            result.actionRecommendation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(height: 16),
        // Z-Score Values (for reference)
        ResultCard(
          title: 'Z-Score Values',
          child: Column(
            children: [
              ResultRow(
                label: 'Weight-for-Age (WAZ)',
                value: formatNumber(result.waz, decimals: 2),
                unit: 'SD',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Height-for-Age (HAZ)',
                value: formatNumber(result.haz, decimals: 2),
                unit: 'SD',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Weight-for-Height (WHZ)',
                value: formatNumber(result.whz, decimals: 2),
                unit: 'SD',
                isHighlighted: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getClassificationColor(
    BuildContext context,
    OverallNutritionClassification classification,
  ) {
    switch (classification) {
      case OverallNutritionClassification.normalGrowth:
        return Colors.green;
      case OverallNutritionClassification.acuteMalnutrition:
        return Colors.orange;
      case OverallNutritionClassification.chronicMalnutrition:
        return Colors.amber;
      case OverallNutritionClassification.mixedMalnutrition:
        return Colors.red;
    }
  }

  IconData _getClassificationIcon(OverallNutritionClassification classification) {
    switch (classification) {
      case OverallNutritionClassification.normalGrowth:
        return Icons.check_circle;
      case OverallNutritionClassification.acuteMalnutrition:
        return Icons.warning;
      case OverallNutritionClassification.chronicMalnutrition:
        return Icons.info;
      case OverallNutritionClassification.mixedMalnutrition:
        return Icons.error;
    }
  }
}
