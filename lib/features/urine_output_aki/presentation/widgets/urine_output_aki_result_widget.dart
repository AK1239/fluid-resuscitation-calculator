import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/urine_output_aki/domain/entities/urine_output_aki_result.dart';

class UrineOutputAkiResultWidget extends StatelessWidget {
  final UrineOutputAkiResult result;

  const UrineOutputAkiResultWidget({super.key, required this.result});

  String _getUrineOutputInterpretationText() {
    switch (result.urineOutputInterpretation) {
      case UrineOutputInterpretation.oliguria:
        return 'Oliguria';
      case UrineOutputInterpretation.normal:
        return 'Normal urine output';
      case UrineOutputInterpretation.polyuria:
        return 'Polyuria';
    }
  }

  String _getAkiStageText() {
    switch (result.akiStage) {
      case AkiStage.noAki:
        return 'No AKI by urine output criteria';
      case AkiStage.stage1:
        return 'Stage 1 AKI';
      case AkiStage.stage2:
        return 'Stage 2 AKI';
      case AkiStage.stage3:
        return 'Stage 3 AKI';
    }
  }

  Color _getUrineOutputColor() {
    switch (result.urineOutputInterpretation) {
      case UrineOutputInterpretation.oliguria:
        return Colors.red;
      case UrineOutputInterpretation.normal:
        return Colors.green;
      case UrineOutputInterpretation.polyuria:
        return Colors.orange;
    }
  }

  Color _getAkiStageColor() {
    switch (result.akiStage) {
      case AkiStage.noAki:
        return Colors.green;
      case AkiStage.stage1:
        return Colors.orange;
      case AkiStage.stage2:
        return Colors.red;
      case AkiStage.stage3:
        return Colors.red.shade900;
    }
  }

  IconData _getAkiStageIcon() {
    switch (result.akiStage) {
      case AkiStage.noAki:
        return Icons.check_circle_outline;
      case AkiStage.stage1:
      case AkiStage.stage2:
      case AkiStage.stage3:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUrineOutputAbnormal =
        result.urineOutputInterpretation != UrineOutputInterpretation.normal;
    final isAkiPresent = result.akiStage != AkiStage.noAki;

    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Urine Volume Produced',
                value: formatNumber(result.urineVolume, decimals: 0),
                unit: 'mL',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Time Interval',
                value: formatNumber(result.timeHours, decimals: 1),
                unit: 'hours',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Urine Output',
                value: formatNumber(
                  result.urineOutputMlPerKgPerHr,
                  decimals: 2,
                ),
                unit: 'mL/kg/hr',
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      isUrineOutputAbnormal
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: _getUrineOutputColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getUrineOutputInterpretationText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getUrineOutputColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ResultRow(
                label: 'KDIGO AKI Stage',
                value: _getAkiStageText(),
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      _getAkiStageIcon(),
                      color: _getAkiStageColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.clinicalMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getAkiStageColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isAkiPresent) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getAkiStageColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getAkiStageColor(), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getAkiStageIcon(),
                      color: _getAkiStageColor(),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getAkiStageText(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getAkiStageColor(),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.clinicalMessage,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _getAkiStageColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (result.akiStage == AkiStage.stage3) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Consider: fluid status assessment, review medications, check for obstruction, and urgent nephrology consultation.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: _getAkiStageColor()),
                  ),
                ],
              ],
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
                    'KDIGO AKI Staging Criteria',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Stage 1: < 0.5 mL/kg/hr for 6–12 hours',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade900),
              ),
              const SizedBox(height: 4),
              Text(
                'Stage 2: < 0.5 mL/kg/hr for ≥ 12 hours',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade900),
              ),
              const SizedBox(height: 4),
              Text(
                'Stage 3: < 0.3 mL/kg/hr for ≥ 24 hours OR anuria (≈0) for ≥ 12 hours',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade900),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This tool is for clinical support only and does not replace clinical judgment.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
