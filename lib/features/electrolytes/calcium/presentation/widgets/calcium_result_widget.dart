import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/electrolytes/calcium/domain/entities/calcium_correction_result.dart';

class CalciumResultWidget extends StatelessWidget {
  final CalciumCorrectionResult result;

  const CalciumResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Calcium Correction',
          child: ResultRow(
            label: 'Estimated Deficit',
            value: formatNumber(result.estimatedDeficit, decimals: 1),
            unit: 'mg',
            isHighlighted: true,
          ),
        ),
        ResultCard(
          title: 'IV Guidance',
          child: Text(
            result.ivGuidance,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        ResultCard(
          title: 'Oral Supplementation',
          child: Text(
            result.oralSupplementation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

