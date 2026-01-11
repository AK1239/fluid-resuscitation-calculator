import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/iron_sucrose/domain/entities/iron_sucrose_result.dart';

class IronSucroseResultWidget extends StatelessWidget {
  final IronSucroseResult result;

  const IronSucroseResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calculation Steps
        ResultCard(
          title: 'Calculation Steps (Ganzoni Formula)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Step 1: Hb deficit',
                value: '${formatNumber(result.targetHb, decimals: 1)} - ${formatNumber(result.actualHb, decimals: 1)} = ${formatNumber(result.hbDeficit, decimals: 1)}',
                unit: 'g/dL',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Step 2: Iron deficit from Hb',
                value: '${formatNumber(result.weightKg, decimals: 1)} × ${formatNumber(result.hbDeficit, decimals: 1)} × 2.4 = ${formatNumber(result.ironDeficitFromHb, decimals: 0)}',
                unit: 'mg',
                isHighlighted: false,
              ),
              if (result.includeIronStores) ...[
                ResultRow(
                  label: 'Step 3: Add iron stores',
                  value: formatNumber(result.ironStores, decimals: 0),
                  unit: 'mg',
                  isHighlighted: false,
                ),
              ],
              const Divider(height: 24),
              ResultRow(
                label: 'Total Iron Deficit',
                value: formatNumber(result.totalIronDeficit, decimals: 0),
                unit: 'mg',
                isHighlighted: true,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✓ Total iron required ≈ ${formatNumber(result.totalIronDeficit, decimals: 0)} mg',
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
        // Dosing Schedule
        ResultCard(
          title: 'Iron Sucrose Dosing',
          child: Column(
            children: [
              ResultRow(
                label: 'Number of doses',
                value: '${result.numberOfDoses} × 200 mg',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Total volume',
                value: formatNumber(result.totalVolume, decimals: 1),
                unit: 'mL',
                isHighlighted: false,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dosing Schedule:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Maximum single dose: 200 mg IV',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '• Can be given 2-3 times per week',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '• No test dose required',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '• Infusion: 200 mg over 30-60 minutes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Clinical Notes
        ResultCard(
          title: 'Clinical Notes',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Special Considerations:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Heart failure / CKD: Consider stepwise dosing (e.g., 1 g total, reassess ferritin & TSAT)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '• Active infection: Avoid IV iron if possible',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Expected Response:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Expected Hb rise: ~1-2 g/dL over 3-4 weeks',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '• Always check ferritin & TSAT if response is poor',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
