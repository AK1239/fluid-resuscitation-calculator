import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

class SodiumResultWidget extends StatelessWidget {
  final SodiumCorrectionResult result;
  final double?
  correctionRate; // Correction rate in mmol/L (targetNa - currentNa)

  const SodiumResultWidget({
    super.key,
    required this.result,
    this.correctionRate,
  });

  @override
  Widget build(BuildContext context) {
    final exceedsSafeRate = correctionRate != null && correctionRate! > 8.0;

    return Column(
      children: [
        if (exceedsSafeRate) ...[
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
                        'Correction Rate Warning',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Correction rate (${formatNumber(correctionRate!, decimals: 1)} mmol/L) exceeds the safe limit of 8 mmol/L per 24 hours. '
                        'Rapid correction may cause serious complications. Consider slower correction over multiple days.',
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
              if (correctionRate != null)
                ResultRow(
                  label: 'Correction Rate',
                  value: formatNumber(correctionRate!, decimals: 1),
                  unit: 'mmol/L',
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
                unit: 'mL',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
