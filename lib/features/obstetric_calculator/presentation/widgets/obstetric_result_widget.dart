import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/obstetric_calculation_result.dart';

class ObstetricResultWidget extends StatelessWidget {
  final ObstetricCalculationResult result;

  const ObstetricResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Given information
        ResultCard(
          title: 'Given',
          child: Column(
            children: [
              ResultRow(
                label: 'LMP',
                value: formatDate(result.lmp),
                isHighlighted: false,
              ),
              ResultRow(
                label: "Today's date",
                value: formatDate(result.today),
                isHighlighted: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // EDD Calculation
        ResultCard(
          title: 'Estimated Date of Delivery (EDD)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculation steps (Naegele\'s rule):',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ResultRow(
                label: 'LMP',
                value: formatDate(result.lmp),
                isHighlighted: false,
              ),
              ResultRow(
                label: '+7 days',
                value: formatDate(result.eddSteps.step1Add7Days),
                isHighlighted: false,
              ),
              ResultRow(
                label: '−3 months',
                value: formatDate(result.eddSteps.step2Subtract3Months),
                isHighlighted: false,
              ),
              ResultRow(
                label: '+1 year',
                value: formatDate(result.eddSteps.step3Add1Year),
                isHighlighted: false,
              ),
              const Divider(height: 24),
              ResultRow(
                label: 'Final EDD',
                value: formatDateWithMonthName(result.edd),
                isHighlighted: true,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ EDD = ${formatDateWithMonthName(result.edd)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Gestational Age
        ResultCard(
          title: 'Gestational Age (GA)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Total days since LMP',
                value: result.totalDays.toString(),
                unit: 'days',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Calculation',
                value:
                    '${result.totalDays} ÷ 7 = ${result.gestationalAgeWeeks} weeks + ${result.gestationalAgeDays} days',
                isHighlighted: false,
              ),
              const Divider(height: 24),
              ResultRow(
                label: 'Gestational Age',
                value:
                    '${result.gestationalAgeWeeks} weeks ${result.gestationalAgeDays} days',
                isHighlighted: true,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ Gestational Age = ${result.gestationalAgeWeeks} weeks ${result.gestationalAgeDays} days',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Clinical Note
        ResultCard(
          title: 'Clinical Note',
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• EDD is an estimate based on LMP.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '• First-trimester ultrasound dating supersedes LMP if discrepancy >5–7 days.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
