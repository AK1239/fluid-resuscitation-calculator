import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

class SodiumResultWidget extends StatelessWidget {
  final SodiumCorrectionResult result;

  const SodiumResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (result.wasAdjusted) ...[
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300, width: 2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe Correction Rate Applied',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your desired target (${formatNumber(result.desiredTargetNa!, decimals: 1)} mEq/L) would require a correction rate exceeding the safe limit of 8 mmol/L per 24 hours. '
                        'The calculation below uses the maximum safe target (${formatNumber(result.safeTargetNa, decimals: 1)} mEq/L) to prevent complications.',
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
        ResultCard(
          title: 'Sodium Correction',
          child: Column(
            children: [
              ResultRow(
                label: 'Safe Target Sodium',
                value: formatNumber(result.safeTargetNa, decimals: 1),
                unit: 'mEq/L',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Correction Rate',
                value: formatNumber(result.correctionRate, decimals: 1),
                unit: 'mmol/L/24h',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Sodium Required',
                value: formatNumber(result.sodiumRequiredMEq, decimals: 1),
                unit: 'mEq',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Volume of 3% Saline',
                value: formatInteger(result.volumeOf3PercentNS),
                unit: 'mL/24hr',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
