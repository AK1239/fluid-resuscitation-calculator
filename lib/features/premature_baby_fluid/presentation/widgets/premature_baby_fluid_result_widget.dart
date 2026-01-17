import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/premature_baby_fluid/domain/entities/premature_baby_fluid_result.dart';

class PrematureBabyFluidResultWidget extends StatelessWidget {
  final PrematureBabyFluidResult result;

  const PrematureBabyFluidResultWidget({super.key, required this.result});

  String _getGestationalCategoryDisplay() {
    switch (result.gestationalCategory) {
      case GestationalCategory.pretermLessThan1000g:
        return 'Preterm <1000 g';
      case GestationalCategory.pretermLessThan35wGreaterThan1000g:
        return 'Preterm <35 weeks & >1000 g';
      case GestationalCategory.termNeonate:
        return 'Term neonate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Gestational Category',
                value: _getGestationalCategoryDisplay(),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Day of Life',
                value: result.dayOfLife.toString(),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Current Weight',
                value: formatNumber(result.currentWeightKg, decimals: 2),
                unit: 'kg',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Calculated Baseline',
                value: formatNumber(
                  result.baselineFluidMlPerKgPerDay,
                  decimals: 0,
                ),
                unit: 'ml/kg/day',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'EBM Feeding',
                value: result.canTakeEbm ? 'Yes' : 'No',
                isHighlighted: false,
              ),
              if (result.canTakeEbm) ...[
                ResultRow(
                  label: 'EBM Volume',
                  value: formatNumber(result.ebmMlPerKgPerDay, decimals: 1),
                  unit: 'ml/kg/day',
                  isHighlighted: false,
                ),
                ResultRow(
                  label: 'Calculated Enteral Volume',
                  value: formatNumber(
                    result.enteralVolumeMlPerDay,
                    decimals: 0,
                  ),
                  unit: 'ml/day',
                  isHighlighted: false,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.tune, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Adjustments Applied',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...result.adjustmentsApplied.map(
                (adjustment) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          adjustment,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.blue.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Fluid Requirements',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ResultRow(
                label: 'Total Fluid Goal',
                value: formatNumber(
                  result.totalAdjustedFluidMlPerDay,
                  decimals: 0,
                ),
                unit: 'ml/day',
                isHighlighted: false,
              ),
              if (result.canTakeEbm && result.enteralVolumeMlPerDay > 0) ...[
                ResultRow(
                  label: 'Enteral Volume',
                  value: formatNumber(
                    result.enteralVolumeMlPerDay,
                    decimals: 0,
                  ),
                  unit: 'ml/day',
                  isHighlighted: false,
                ),
                ResultRow(
                  label: 'Breast Milk per Feed',
                  value: formatNumber(
                    result.enteralVolumeMlPerDay / 8,
                    decimals: 1,
                  ),
                  unit: 'ml every 3 hours',
                  isHighlighted: false,
                ),
              ],
              ResultRow(
                label: 'Final IV Fluid Volume',
                value: formatNumber(
                  result.finalIvFluidVolumeMlPerDay,
                  decimals: 0,
                ),
                unit: 'ml/day',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'IV Rate',
                value: formatNumber(result.ivRateMlPerHour, decimals: 1),
                unit: 'ml/hour',
                isHighlighted: true,
              ),
              const Divider(),
              ResultRow(
                label: 'Fluid Type',
                value: result.fluidType == FluidType.d10 ? 'D10' : 'D10 0.2NS',
                isHighlighted: false,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.science, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Fluid Composition',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.fluidComposition,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.green.shade900),
              ),
            ],
          ),
        ),
        if (result.safetyNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Clinical Safety Notes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...result.safetyNotes.map(
                  (note) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: Text(
                            note,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.amber.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
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
