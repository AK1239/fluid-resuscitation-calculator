import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/domain/entities/pediatric_burn_resuscitation_result.dart';

class PediatricBurnResuscitationResultWidget extends StatelessWidget {
  final PediatricBurnResuscitationResult result;

  const PediatricBurnResuscitationResultWidget({
    super.key,
    required this.result,
  });

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
              'Patient may not meet formal indication for fluid resuscitation (≥10% TBSA, or any burn with shock, electrical injury, or inhalation injury). Consider clinical judgment.',
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
                label: 'Step 1: Total 24-hour burn fluid',
                value:
                    '4 mL × ${formatNumber(result.weightKg, decimals: 1)} kg × ${formatNumber(result.tbsaPercent, decimals: 1)}% = ${formatNumber(result.totalBurnFluid24h, decimals: 0)}',
                unit: 'mL',
                isHighlighted: false,
              ),
              const Divider(height: 24),
              ResultRow(
                label: 'Total burn fluid (24 hours)',
                value: formatNumber(result.totalBurnFluid24h, decimals: 0),
                unit: 'mL Ringer\'s Lactate',
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
                  '✓ Total burn fluid = ${formatNumber(result.totalBurnFluid24h, decimals: 0)} mL RL over 24 hours',
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
        // Maintenance Fluids
        ResultCard(
          title: 'Maintenance Fluids (Holliday-Segar)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Maintenance fluid rate',
                value: formatNumber(
                  result.maintenanceFluidHourlyRate,
                  decimals: 1,
                ),
                unit: 'mL/hr',
                isHighlighted: true,
              ),
              const SizedBox(height: 8),
              Text(
                'Fluid type: D5 0.45% NS or D5 RL (institution-dependent)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Maintenance runs continuously over 24 hours',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Fluid Distribution
        ResultCard(
          title: 'Burn Fluid Distribution',
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
                  label: 'Burn fluid hourly rate',
                  value: formatNumber(result.first8hHourlyRate, decimals: 0),
                  unit: 'mL/hr RL',
                  isHighlighted: false,
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
                label: 'Burn fluid hourly rate',
                value: formatNumber(result.next16hHourlyRate, decimals: 1),
                unit: 'mL/hr RL',
                isHighlighted: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Total Hourly Rates
        ResultCard(
          title: 'Total Hourly Fluid Rates',
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total hourly rate = Burn resuscitation rate + Maintenance rate',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              if (result.timeSinceBurnHours < 8) ...[
                ResultRow(
                  label:
                      'First 8 hours (next ${result.first8hRemainingHours} hours)',
                  value: formatNumber(
                    result.first8hTotalHourlyRate,
                    decimals: 1,
                  ),
                  unit: 'mL/hr',
                  isHighlighted: true,
                ),
                const SizedBox(height: 8),
                Text(
                  '  • Burn fluid: ${formatNumber(result.first8hHourlyRate, decimals: 0)} mL/hr RL',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '  • Maintenance: ${formatNumber(result.maintenanceFluidHourlyRate, decimals: 1)} mL/hr',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Divider(height: 24),
              ],
              ResultRow(
                label: 'Next 16 hours',
                value: formatNumber(result.next16hTotalHourlyRate, decimals: 1),
                unit: 'mL/hr',
                isHighlighted: true,
              ),
              const SizedBox(height: 8),
              Text(
                '  • Burn fluid: ${formatNumber(result.next16hHourlyRate, decimals: 1)} mL/hr RL',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '  • Maintenance: ${formatNumber(result.maintenanceFluidHourlyRate, decimals: 1)} mL/hr',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary
        ResultCard(
          title: 'Pediatric Burn Fluid Plan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResultRow(
                label: 'Burn resuscitation volume (24 h)',
                value: formatNumber(result.totalBurnFluid24h, decimals: 0),
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
                          'First 8 h',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '${formatNumber(result.first8hVolume, decimals: 0)} mL (${formatNumber(result.first8hTotalHourlyRate, decimals: 0)} mL/hr for next ${result.first8hRemainingHours} h)',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ResultRow(
                label: 'Next 16 h',
                value:
                    '${formatNumber(result.next16hVolume, decimals: 0)} mL (${formatNumber(result.next16hTotalHourlyRate, decimals: 0)} mL/hr)',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Maintenance fluids',
                value:
                    '${formatNumber(result.maintenanceFluidHourlyRate, decimals: 1)} mL/hr (D5-containing)',
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
        // Clinical Monitoring Reminders
        ResultCard(
          title: 'Clinical Monitoring Reminders',
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Adjust fluids hourly based on urine output and perfusion',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '• Urine output is the primary titration endpoint',
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
              if (result.hasElectricalInjury) ...[
                const SizedBox(height: 8),
                Text(
                  '• Electrical burn - maintain higher urine output target (≥1.5 mL/kg/hr)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Safety Note
        ResultCard(
          title: 'Safety Warnings',
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Parkland is a starting estimate, not a fixed prescription',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '• Avoid fluid creep → risk of pulmonary edema & abdominal compartment syndrome',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '• Children are at risk of hypoglycemia → maintenance fluids are essential',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.orange.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Do NOT mix dextrose into the Parkland volume',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '• Consider albumin after 24 hours if escalating crystalloid needs',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
