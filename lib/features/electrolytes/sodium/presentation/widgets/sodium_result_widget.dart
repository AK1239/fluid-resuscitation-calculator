import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

class SodiumResultWidget extends StatelessWidget {
  final SodiumCorrectionResult result;

  const SodiumResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Sodium Correction',
          child: Column(
            children: [
              ResultRow(
                label: 'Sodium Required',
                value: formatNumber(result.sodiumRequiredMEq, decimals: 1),
                unit: 'mEq',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Volume of 3% NS',
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

