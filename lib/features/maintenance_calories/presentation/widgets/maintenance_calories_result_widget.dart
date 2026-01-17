import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/maintenance_calories/domain/entities/maintenance_calories_result.dart';

class MaintenanceCaloriesResultWidget extends StatelessWidget {
  final MaintenanceCaloriesResult result;

  const MaintenanceCaloriesResultWidget({super.key, required this.result});

  String _getCategoryDisplayName() {
    final range = PatientCategoryRange.ranges[result.category]!;
    return range.displayName;
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
                label: 'Patient Weight',
                value: formatNumber(result.weightKg, decimals: 1),
                unit: 'kg',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Patient Category',
                value: _getCategoryDisplayName(),
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Caloric Target',
                value: formatNumber(result.kcalPerKgPerDay, decimals: 1),
                unit: 'kcal/kg/day',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Total Daily Calories',
                value: formatNumber(result.totalDailyCalories, decimals: 0),
                unit: 'kcal/day',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Dextrose Required',
                value: formatNumber(result.gramsDextrosePerDay, decimals: 1),
                unit: 'g/day',
                isHighlighted: false,
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
                    Icons.medical_information_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'IV Fluid Volumes / 24 Hours',
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
                label: 'DNS',
                value: formatInteger(result.volumeDnsMl),
                unit: 'mL/24h',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'D5',
                value: formatInteger(result.volumeD5Ml),
                unit: 'mL/24h',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'D10',
                value: formatInteger(result.volumeD10Ml),
                unit: 'mL/24h',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'D50',
                value: formatInteger(result.volumeD50Ml),
                unit: 'mL/24h',
                isHighlighted: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade300, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber.shade700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Calculated to meet caloric requirement only (electrolytes and fluids not included)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w500,
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
                    'Calculation Details',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Formula: Total Calories = Weight × kcal/kg/day',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade900,
                      fontFamily: 'monospace',
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dextrose = Total Calories ÷ 4 kcal/g',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade900,
                      fontFamily: 'monospace',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Solution concentrations:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '• DNS: 50 g/L\n'
                '• D5: 50 g/L\n'
                '• D10: 100 g/L\n'
                '• D50: 500 g/L',
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
}