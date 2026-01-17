import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/renal_dose_adjustment/domain/entities/renal_dose_adjustment_result.dart';

class RenalDoseAdjustmentResultWidget extends StatelessWidget {
  final RenalDoseAdjustmentResult result;

  const RenalDoseAdjustmentResultWidget({super.key, required this.result});

  String _getRenalFunctionInterpretation(double crCl) {
    if (crCl >= 90) {
      return 'Normal renal function. No dose adjustment typically needed.';
    } else if (crCl >= 60) {
      return 'Mild renal impairment. Monitor for drug accumulation. Consider dose adjustment based on drug-specific guidelines.';
    } else if (crCl >= 30) {
      return 'Moderate renal impairment. Dose adjustment recommended. Consult drug-specific dosing guidelines.';
    } else if (crCl >= 15) {
      return 'Severe renal impairment. Significant dose adjustment required. Consult drug-specific dosing guidelines and consider therapeutic drug monitoring.';
    } else if (crCl >= 10) {
      return 'Kidney failure. Consider dialysis-dependent dosing or alternative medications. Consult nephrology.';
    } else {
      return 'Severe kidney failure (CrCl < 10 mL/min). Consider dialysis-dependent dosing or alternative medications. Consult nephrology.';
    }
  }

  String _getRenalFunctionStageText() {
    switch (result.renalFunctionStage) {
      case RenalFunctionStage.normal:
        return 'Normal (CrCl > 90 mL/min)';
      case RenalFunctionStage.mildImpairment:
        return 'Mild impairment (CrCl 60-90 mL/min)';
      case RenalFunctionStage.moderateImpairment:
        return 'Moderate impairment (CrCl 30-59 mL/min)';
      case RenalFunctionStage.severeImpairment:
        return 'Severe impairment (CrCl 15-29 mL/min)';
      case RenalFunctionStage.kidneyFailure:
        return 'Kidney failure (CrCl < 15 mL/min)';
    }
  }

  Color _getRenalFunctionColor() {
    switch (result.renalFunctionStage) {
      case RenalFunctionStage.normal:
        return Colors.green;
      case RenalFunctionStage.mildImpairment:
        return Colors.orange;
      case RenalFunctionStage.moderateImpairment:
        return Colors.red;
      case RenalFunctionStage.severeImpairment:
        return Colors.red.shade700;
      case RenalFunctionStage.kidneyFailure:
        return Colors.red.shade900;
    }
  }

  IconData _getRenalFunctionIcon() {
    switch (result.renalFunctionStage) {
      case RenalFunctionStage.normal:
        return Icons.check_circle_outline;
      case RenalFunctionStage.mildImpairment:
      case RenalFunctionStage.moderateImpairment:
      case RenalFunctionStage.severeImpairment:
      case RenalFunctionStage.kidneyFailure:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAbnormal = result.renalFunctionStage != RenalFunctionStage.normal;

    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Serum Creatinine',
                value: formatNumber(result.serumCreatinine, decimals: 1),
                unit: 'μmol/L',
                isHighlighted: false,
              ),
              ResultRow(
                label: 'Serum Creatinine',
                value: formatNumber(result.serumCreatinineMgPerDl, decimals: 2),
                unit: 'mg/dL',
                isHighlighted: false,
              ),
              const Divider(),
              ResultRow(
                label: 'Creatinine Clearance',
                value: formatNumber(result.creatinineClearance, decimals: 1),
                unit: 'mL/min',
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getRenalFunctionIcon(),
                      color: _getRenalFunctionColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getRenalFunctionStageText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getRenalFunctionColor(),
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
        if (result.requiresDialysis) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade700, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Critical Alert: CrCl < 10 mL/min',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Severe kidney failure detected. Patient may require dialysis-dependent dosing or alternative medications. Consult nephrology before proceeding.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (isAbnormal) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getRenalFunctionColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getRenalFunctionColor(), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getRenalFunctionIcon(),
                      color: _getRenalFunctionColor(),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Renal Function Interpretation',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getRenalFunctionColor(),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getRenalFunctionInterpretation(result.creatinineClearance),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _getRenalFunctionColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Note: CrCl is used to assess renal function. Consult drug-specific dosing guidelines for dose adjustments based on CrCl.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getRenalFunctionColor(),
                  ),
                ),
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
                    'Cockcroft-Gault Formula',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'CrCl = [(140 - age) × weight × (0.85 if female)] / (72 × SCr)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade900,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Where:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• CrCl = Creatinine Clearance (mL/min)\n'
                '• Age in years\n'
                '• Weight in kg\n'
                '• SCr = Serum Creatinine (mg/dL)',
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
                  'This calculator provides an estimate of creatinine clearance. Clinical judgment and drug-specific dosing guidelines should be used for therapeutic decisions.',
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
