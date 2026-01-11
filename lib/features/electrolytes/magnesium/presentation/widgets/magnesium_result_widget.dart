import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/features/electrolytes/magnesium/domain/entities/magnesium_correction_result.dart';

class MagnesiumResultWidget extends StatelessWidget {
  final MagnesiumCorrectionResult result;

  const MagnesiumResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultCard(
          title: 'Suggested Dosing',
          child: Text(
            result.suggestedDosing,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        ResultCard(
          title: 'Expected Serum Rise',
          child: Text(
            result.expectedSerumRise,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        ResultCard(
          title: 'Monitoring Reminders',
          child: Text(
            result.monitoringReminders,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

