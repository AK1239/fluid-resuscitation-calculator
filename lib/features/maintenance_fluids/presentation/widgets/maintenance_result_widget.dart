import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/maintenance_fluids/domain/entities/maintenance_fluid_result.dart';

class MaintenanceResultWidget extends StatelessWidget {
  final MaintenanceFluidResult result;

  const MaintenanceResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Maintenance Fluids',
          child: Column(
            children: [
              ResultRow(
                label: 'Daily Total',
                value: formatInteger(result.dailyTotal),
                unit: 'mL/day',
                isHighlighted: true,
              ),
              ResultRow(
                label: 'Hourly Rate',
                value: formatRate(result.hourlyRate),
                isHighlighted: true,
              ),
            ],
          ),
        ),
        ResultCard(
          title: 'Additional Information',
          child: Text(
            result.additionalInfo,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

