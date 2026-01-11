import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/fluid_resuscitation/domain/entities/fluid_resuscitation_result.dart';

class FluidResultWidget extends StatelessWidget {
  final FluidResuscitationResult result;

  const FluidResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Total Fluid Deficit',
          child: ResultRow(
            label: 'Deficit',
            value: formatInteger(result.totalDeficit),
            unit: 'mL',
            isHighlighted: true,
          ),
        ),
        ResultCard(
          title: 'Phase 1: Rapid Resuscitation',
          child: Column(
            children: [
              ResultRow(
                label: 'Volume',
                value: formatInteger(result.phase1Volume),
                unit: 'mL',
              ),
              ResultRow(
                label: 'Duration',
                value: formatInteger(result.phase1Duration),
                unit: 'minutes',
              ),
              ResultRow(
                label: 'Rate',
                value: formatRate(result.phase1Volume / (result.phase1Duration / 60)),
                isHighlighted: true,
              ),
            ],
          ),
        ),
        ResultCard(
          title: 'Phase 2: Continued Resuscitation',
          child: Column(
            children: [
              ResultRow(
                label: 'Deficit Volume',
                value: formatInteger(result.phase2DeficitVolume),
                unit: 'mL',
              ),
              ResultRow(
                label: 'Total Volume',
                value: formatInteger(result.phase2TotalVolume),
                unit: 'mL',
              ),
              ResultRow(
                label: 'Duration',
                value: formatInteger(result.phase2Duration),
                unit: 'hours',
              ),
              ResultRow(
                label: 'Hourly Rate',
                value: formatRate(result.phase2HourlyRate),
                isHighlighted: true,
              ),
            ],
          ),
        ),
        ResultCard(
          title: 'Phase 3: Final Resuscitation',
          child: Column(
            children: [
              ResultRow(
                label: 'Deficit Volume',
                value: formatInteger(result.phase3DeficitVolume),
                unit: 'mL',
              ),
              ResultRow(
                label: 'Total Volume',
                value: formatInteger(result.phase3TotalVolume),
                unit: 'mL',
              ),
              ResultRow(
                label: 'Duration',
                value: formatInteger(result.phase3Duration),
                unit: 'hours',
              ),
              ResultRow(
                label: 'Hourly Rate',
                value: formatRate(result.phase3HourlyRate),
                isHighlighted: true,
              ),
            ],
          ),
        ),
        ResultCard(
          title: 'Maintenance Fluids',
          child: ResultRow(
            label: 'Daily Total',
            value: formatInteger(result.maintenanceFluidsPerDay),
            unit: 'mL/day',
          ),
        ),
      ],
    );
  }
}

