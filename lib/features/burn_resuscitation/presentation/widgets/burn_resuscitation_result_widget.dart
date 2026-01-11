import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/burn_resuscitation/domain/entities/burn_resuscitation_result.dart';

class BurnResuscitationResultWidget extends StatelessWidget {
  final BurnResuscitationResult result;

  const BurnResuscitationResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indication Check
        if (!result.meetsIndication)
          ResultCard(
            title: 'Indication Note',
            backgroundColor: Colors.orange.shade50,
            child: Text(
              'Patient may not meet formal indication for fluid resuscitation (Adults ≥10-15% TBSA, Children ≥10% TBSA). Consider clinical judgment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        if (!result.meetsIndication) const SizedBox(height: 16),
        // Calculation Steps
        ResultCard(
          title: 'Calculation Steps (Parkland Formula)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Step 1: Total 24-hour fluid',
                value:
                    '4 mL × ${formatNumber(result.weightKg, decimals: 1)} kg × ${formatNumber(result.tbsaPercent, decimals: 1)}% = ${formatNumber(result.totalFluid24h, decimals: 0)}',
                unit: 'mL',
                isHighlighted: false,
              ),
              const Divider(height: 24),
              ResultRow(
                label: 'Total fluid (24 hours)',
                value: formatNumber(result.totalFluid24h, decimals: 0),
                unit: 'mL Ringer\'s Lactate',
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
                  '✓ Total fluid = ${formatNumber(result.totalFluid24h, decimals: 0)} mL RL over 24 hours',
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
        // Fluid Distribution
        ResultCard(
          title: 'Fluid Distribution',
          child: Column(
            children: [
              ResultRow(
                label: 'First 8 hours',
                value: formatNumber(result.first8hVolume, decimals: 0),
                unit: 'mL (50% of total)',
                isHighlighted: false,
              ),
              if (result.timeSinceBurnHours < 8) ...[
                ResultRow(
                  label: 'Time remaining in first 8 hours',
                  value: '${result.first8hRemainingHours} hours',
                  isHighlighted: false,
                ),
                ResultRow(
                  label: 'Hourly rate (remaining time)',
                  value: formatNumber(result.first8hHourlyRate, decimals: 0),
                  unit: 'mL/hr',
                  isHighlighted: true,
                ),
              ] else ...[
                ResultRow(
                  label: 'Note',
                  value: 'Patient presented after 8 hours',
                  isHighlighted: false,
                ),
              ],
              const Divider(height: 24),
              ResultRow(
                label: 'Next 16 hours',
                value: formatNumber(result.next16hVolume, decimals: 0),
                unit: 'mL (50% of total)',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Hourly rate',
                value: formatNumber(result.next16hHourlyRate, decimals: 1),
                unit: 'mL/hr',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary
        ResultCard(
          title: 'Summary',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Total fluid (24 h)',
                value: formatNumber(result.totalFluid24h, decimals: 0),
                unit: 'mL RL',
                isHighlighted: true,
              ),
              if (result.timeSinceBurnHours < 8) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'First 8 hours',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${formatNumber(result.first8hVolume, decimals: 0)} mL (${formatNumber(result.first8hHourlyRate, decimals: 0)} mL/hr for next ${result.first8hRemainingHours} hours)',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ResultRow(
                label: 'Next 16 hours',
                value:
                    '${formatNumber(result.next16hVolume, decimals: 0)} mL (≈${formatNumber(result.next16hHourlyRate, decimals: 0)} mL/hr)',
                isHighlighted: false,
              ),
              const Divider(height: 24),
              ResultRow(
                label: 'Urine output target',
                value:
                    '≥${formatNumber(result.urineOutputTarget, decimals: 1)} mL/kg/hr',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Monitoring Reminders
        ResultCard(
          title: 'Clinical Monitoring Reminders',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Adjust fluids based on urine output and hemodynamics',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '• Reassess hourly urine output and vitals',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (result.hasInhalationInjury) ...[
                const SizedBox(height: 8),
                Text(
                  '• Inhalation injury present - may require increased fluids (clinical judgment)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade900,
                      ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '• Avoid over-resuscitation (risk of abdominal compartment syndrome)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Safety Note
        ResultCard(
          title: 'Safety Note',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• This is an initial estimate, not a fixed prescription',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Reassess hourly urine output and vitals',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '• Avoid over-resuscitation (risk of abdominal compartment syndrome)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
