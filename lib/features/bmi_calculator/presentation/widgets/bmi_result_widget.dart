import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/bmi_calculator/domain/entities/bmi_result.dart';

class BmiResultWidget extends StatelessWidget {
  final BmiResult result;

  const BmiResultWidget({super.key, required this.result});

  String _getBmiCategoryText() {
    switch (result.category) {
      case BmiCategory.underweight:
        return 'Underweight (< 18.5)';
      case BmiCategory.normalWeight:
        return 'Normal weight (18.5 - 24.9)';
      case BmiCategory.overweight:
        return 'Overweight (25.0 - 29.9)';
      case BmiCategory.obesityClass1:
        return 'Obesity Class I (30.0 - 34.9)';
      case BmiCategory.obesityClass2:
        return 'Obesity Class II (35.0 - 39.9)';
      case BmiCategory.obesityClass3:
        return 'Obesity Class III (≥ 40.0)';
    }
  }

  Color _getBmiCategoryColor() {
    switch (result.category) {
      case BmiCategory.underweight:
        return Colors.orange;
      case BmiCategory.normalWeight:
        return Colors.green;
      case BmiCategory.overweight:
        return Colors.orange.shade700;
      case BmiCategory.obesityClass1:
        return Colors.red;
      case BmiCategory.obesityClass2:
        return Colors.red.shade700;
      case BmiCategory.obesityClass3:
        return Colors.red.shade900;
    }
  }

  IconData _getBmiCategoryIcon() {
    switch (result.category) {
      case BmiCategory.underweight:
      case BmiCategory.normalWeight:
        return Icons.check_circle_outline;
      case BmiCategory.overweight:
      case BmiCategory.obesityClass1:
      case BmiCategory.obesityClass2:
      case BmiCategory.obesityClass3:
        return Icons.warning_amber_rounded;
    }
  }

  String _getWorkedExampleText() {
    final weightKg = result.weightKg;
    final heightM = result.heightM;
    final heightSquared = heightM * heightM;
    final bmi = result.bmi;

    return 'BMI = ${weightKg.toStringAsFixed(1)} ÷ (${heightM.toStringAsFixed(2)} × ${heightM.toStringAsFixed(2)})\n'
        'BMI = ${weightKg.toStringAsFixed(1)} ÷ ${heightSquared.toStringAsFixed(2)}\n'
        'BMI = ${bmi.toStringAsFixed(1)} kg/m²';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getBmiCategoryColor();
    final isAbnormal = result.category != BmiCategory.normalWeight;

    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Weight',
                value: formatNumber(result.weightKg, decimals: 1),
                unit: 'kg',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Height',
                value: formatNumber(result.heightM, decimals: 2),
                unit: 'm',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'BMI',
                value: formatNumber(result.bmi, decimals: 1),
                unit: 'kg/m²',
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getBmiCategoryIcon(),
                      color: categoryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getBmiCategoryText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: categoryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: categoryColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getBmiCategoryIcon(),
                    color: categoryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'BMI Interpretation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.interpretation,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Worked Example',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _getWorkedExampleText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade900,
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'BMI Formula',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'BMI = weight (kg) ÷ [height (m)]²',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade900,
                      fontFamily: 'monospace',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'WHO Classification:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '• < 18.5 → Underweight\n'
                '• 18.5 - 24.9 → Normal weight\n'
                '• 25.0 - 29.9 → Overweight\n'
                '• 30.0 - 34.9 → Obesity Class I\n'
                '• 35.0 - 39.9 → Obesity Class II\n'
                '• ≥ 40.0 → Obesity Class III',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade900,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'BMI is a screening tool and does not directly measure body fat. Clinical judgment and additional assessments should be used for comprehensive evaluation.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}