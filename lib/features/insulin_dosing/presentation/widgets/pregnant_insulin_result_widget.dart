import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/insulin_dosing/domain/entities/pregnant_insulin_result.dart';

class PregnantInsulinResultWidget extends StatelessWidget {
  final PregnantInsulinResult result;

  const PregnantInsulinResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Total Daily Insulin Dose',
          child: Column(
            children: [
              ResultRow(
                label: 'TDD',
                value: formatNumber(result.totalDailyDose, decimals: 1),
                unit: 'units/day',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Calculation',
                value:
                    '${formatNumber(result.maternalWeightKg, decimals: 1)} kg × ${_getUnitsPerKg(result.trimester, result.obesityClass)} U/kg',
                isHighlighted: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (result.requiresFourInjectionRegimen) ...[
          ResultCard(
            title: 'Four-Injection Regimen',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.morningBasal != null)
                  _InjectionRow(
                    timing: 'Before breakfast',
                    insulinType: 'NPH (basal)',
                    units: result.morningBasal!,
                    rationale: '2/3 of morning dose (2/3 of TDD)',
                  ),
                if (result.morningRapidActingFourInjection != null)
                  _InjectionRow(
                    timing: 'Before breakfast',
                    insulinType: 'Rapid-acting (lispro/aspart)',
                    units: result.morningRapidActingFourInjection!,
                    rationale: '1/3 of morning dose',
                  ),
                if (result.lunchRapidActing != null)
                  _InjectionRow(
                    timing: 'Before lunch',
                    insulinType: 'Rapid-acting (lispro/aspart)',
                    units: result.lunchRapidActing!,
                    rationale: 'Post-lunch hyperglycemia',
                  ),
                if (result.dinnerRapidActing != null)
                  _InjectionRow(
                    timing: 'Before dinner',
                    insulinType: 'Rapid-acting (lispro/aspart)',
                    units: result.dinnerRapidActing!,
                    rationale: '1/2 of evening dose (1/3 of TDD)',
                  ),
                if (result.bedtimeBasal != null)
                  _InjectionRow(
                    timing: 'Bedtime',
                    insulinType: 'NPH or Long-acting (glargine)',
                    units: result.bedtimeBasal!,
                    rationale: '1/2 of evening dose',
                  ),
              ],
            ),
          ),
        ] else ...[
          ResultCard(
            title: 'Standard Initial Regimen',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.morningNph != null)
                  _InjectionRow(
                    timing: 'Before breakfast',
                    insulinType: 'NPH (basal)',
                    units: result.morningNph!,
                    rationale: 'Starting dose: 10-20 units',
                  ),
                if (result.morningRapidActing != null)
                  _InjectionRow(
                    timing: 'Before breakfast',
                    insulinType: 'Rapid-acting (lispro/aspart)',
                    units: result.morningRapidActing!,
                    rationale: 'Starting dose: 6-10 units',
                  ),
              ],
            ),
          ),
        ],
        if (result.adjustments.isNotEmpty) ...[
          const SizedBox(height: 16),
          ResultCard(
            title: 'Adjustment Recommendations',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: result.adjustments.map((adjustment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(
                        child: Text(
                          adjustment,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Clinical Notes',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Doses are starting points and will be titrated based on glucose patterns\n'
                '• Monitor blood glucose closely and adjust as needed\n'
                '• All doses require clinical confirmation before administration',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade900,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getUnitsPerKg(String trimester, String obesityClass) {
    if (obesityClass == "Class II" || obesityClass == "Class III") {
      return "1.5-2.0";
    }
    if (trimester == "2nd") {
      return "0.9";
    } else if (trimester == "3rd") {
      return "1.0";
    }
    return "0.7-2.0";
  }
}

class _InjectionRow extends StatelessWidget {
  final String timing;
  final String insulinType;
  final double units;
  final String rationale;

  const _InjectionRow({
    required this.timing,
    required this.insulinType,
    required this.units,
    required this.rationale,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timing,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      insulinType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatNumber(units, decimals: 1),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'units',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            rationale,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
