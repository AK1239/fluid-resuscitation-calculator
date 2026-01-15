import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/norepinephrine/domain/entities/norepinephrine_result.dart';

class NorepinephrineResultWidget extends StatelessWidget {
  final NorepinephrineResult result;

  const NorepinephrineResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Infusion Calculation',
          child: Column(
            children: [
              ResultRow(
                label: 'Concentration',
                value: formatNumber(result.concentrationUgPerMl, decimals: 0),
                unit: 'µg/mL',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Step 1: Dose per minute',
                value: formatNumber(result.dosePerMinute, decimals: 2),
                unit: 'µg/min',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Step 2: Dose per hour',
                value: formatNumber(result.dosePerHour, decimals: 1),
                unit: 'µg/hour',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Infusion Rate',
                value: formatNumber(result.infusionRateMlPerHour, decimals: 2),
                unit: 'mL/hour',
                isHighlighted: true,
              ),
            ],
          ),
        ),
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
                Icons.check_circle_outline,
                color: Colors.green.shade700,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Infusion Rate',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatNumber(result.infusionRateMlPerHour, decimals: 2)} mL/hour',
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
        if (result.doseUgPerKgPerMin > 1.0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300, width: 2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'High Dose Warning',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dose exceeds 1 µg/kg/min. Higher doses increase ischemic risk. Monitor patient closely.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.orange.shade900,
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
