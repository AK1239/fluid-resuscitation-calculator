import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/ultrasound_calculation_result.dart';

class UltrasoundResultWidget extends StatelessWidget {
  final UltrasoundCalculationResult result;

  const UltrasoundResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Date of Ultrasound',
                value: formatDate(result.ultrasoundDate),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'GA at Ultrasound',
                value:
                    '${result.gaWeeksAtUltrasound}+${result.gaDaysAtUltrasound}',
                unit: 'weeks + days',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Calculation Date',
                value: formatDate(result.calculationDate),
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Current Gestational Age',
                value:
                    '${result.currentGaWeeks}+${result.currentGaDays}',
                unit: 'weeks + days',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ResultCard(
          title: 'Calculation Steps',
          child: Column(
            children: [
              ResultRow(
                label: 'Step 1: GA at ultrasound (days)',
                value: '${result.totalGaDaysAtUltrasound}',
                unit: 'days',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Step 2: Days elapsed',
                value: '${result.daysElapsed}',
                unit: 'days',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Step 3: Current GA (total days)',
                value: '${result.totalCurrentGaDays}',
                unit: 'days',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Step 4: Current GA (weeks + days)',
                value:
                    '${result.currentGaWeeks}+${result.currentGaDays}',
                unit: 'weeks + days',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        if (result.edd != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.green.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Date of Delivery',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatDate(result.edd!),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
