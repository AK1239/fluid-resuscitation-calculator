import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/insulin_dosing/domain/entities/insulin_dosing_result.dart';

class InsulinResultWidget extends StatelessWidget {
  final InsulinDosingResult result;

  const InsulinResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResultCard(
          title: 'Total Daily Dose (TDD)',
          child: ResultRow(
            label: 'Total Daily Dose',
            value: formatNumber(result.totalDailyDose, decimals: 1),
            unit: 'units',
            isHighlighted: true,
          ),
        ),
        const SizedBox(height: 16),
        ResultCard(
          title: 'Morning Dose (2/3 of TDD)',
          child: Column(
            children: [
              ResultRow(
                label: 'Total Morning Dose',
                value: formatNumber(result.morningDoseTotal, decimals: 1),
                unit: 'units',
                isHighlighted: false,
              ),
              const SizedBox(height: 8),
              ResultRow(
                label: 'Insoluble (NPH)',
                value: formatNumber(result.morningInsoluble, decimals: 1),
                unit: 'units',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Soluble (Regular)',
                value: formatNumber(result.morningSoluble, decimals: 1),
                unit: 'units',
                isHighlighted: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ResultCard(
          title: 'Evening Dose (1/3 of TDD)',
          child: Column(
            children: [
              ResultRow(
                label: 'Total Evening Dose',
                value: formatNumber(result.eveningDoseTotal, decimals: 1),
                unit: 'units',
                isHighlighted: false,
              ),
              const SizedBox(height: 8),
              ResultRow(
                label: 'Insoluble (NPH)',
                value: formatNumber(result.eveningInsoluble, decimals: 1),
                unit: 'units',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Soluble (Regular)',
                value: formatNumber(result.eveningSoluble, decimals: 1),
                unit: 'units',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
