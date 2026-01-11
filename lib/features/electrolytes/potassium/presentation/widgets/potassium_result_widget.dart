import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/electrolytes/potassium/domain/entities/potassium_correction_result.dart';

class PotassiumResultWidget extends StatelessWidget {
  final PotassiumCorrectionResult result;

  const PotassiumResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Potassium Correction',
          child: Column(
            children: [
              ResultRow(
                label: 'Potassium Required',
                value: formatNumber(result.potassiumRequiredMMol, decimals: 1),
                unit: 'mmol',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Slow-K Tablets',
                value: result.slowKTablets.toString(),
                unit: 'tablets',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        ResultCard(
          title: 'IV Guidance',
          child: Text(
            result.ivGuidance,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

