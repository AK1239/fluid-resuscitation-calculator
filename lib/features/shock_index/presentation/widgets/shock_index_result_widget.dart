import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/shock_index/domain/entities/shock_index_result.dart';

class ShockIndexResultWidget extends StatelessWidget {
  final ShockIndexResult result;

  const ShockIndexResultWidget({super.key, required this.result});

  String _getShockIndexInterpretationText() {
    switch (result.shockIndexInterpretation) {
      case ShockIndexInterpretation.normal:
        return 'Normal / Low risk';
      case ShockIndexInterpretation.borderline:
        return 'Borderline / Monitor closely';
      case ShockIndexInterpretation.highRisk:
        return 'High risk – suggests shock';
      case ShockIndexInterpretation.severe:
        return 'Severe shock – high mortality risk';
    }
  }

  String _getTasiInterpretationText() {
    if (result.tasiInterpretation == null) return '';
    switch (result.tasiInterpretation!) {
      case TraumaAdjustedShockIndexInterpretation.lowRisk:
        return 'Low risk';
      case TraumaAdjustedShockIndexInterpretation.moderateRisk:
        return 'Moderate risk – monitor closely';
      case TraumaAdjustedShockIndexInterpretation.highRisk:
        return 'High risk – probable severe injury';
      case TraumaAdjustedShockIndexInterpretation.veryHighRisk:
        return 'Very high risk – high mortality, activate trauma protocols';
    }
  }

  Color _getShockIndexColor() {
    switch (result.shockIndexInterpretation) {
      case ShockIndexInterpretation.normal:
        return Colors.green;
      case ShockIndexInterpretation.borderline:
        return Colors.orange;
      case ShockIndexInterpretation.highRisk:
        return Colors.red;
      case ShockIndexInterpretation.severe:
        return Colors.red.shade900;
    }
  }

  Color _getTasiColor() {
    if (result.tasiInterpretation == null) return Colors.grey;
    switch (result.tasiInterpretation!) {
      case TraumaAdjustedShockIndexInterpretation.lowRisk:
        return Colors.green;
      case TraumaAdjustedShockIndexInterpretation.moderateRisk:
        return Colors.orange;
      case TraumaAdjustedShockIndexInterpretation.highRisk:
        return Colors.red;
      case TraumaAdjustedShockIndexInterpretation.veryHighRisk:
        return Colors.red.shade900;
    }
  }

  IconData _getShockIndexIcon() {
    switch (result.shockIndexInterpretation) {
      case ShockIndexInterpretation.normal:
        return Icons.check_circle_outline;
      case ShockIndexInterpretation.borderline:
      case ShockIndexInterpretation.highRisk:
      case ShockIndexInterpretation.severe:
        return Icons.warning_amber_rounded;
    }
  }

  IconData _getTasiIcon() {
    if (result.tasiInterpretation == null) return Icons.info_outline;
    switch (result.tasiInterpretation!) {
      case TraumaAdjustedShockIndexInterpretation.lowRisk:
        return Icons.check_circle_outline;
      case TraumaAdjustedShockIndexInterpretation.moderateRisk:
      case TraumaAdjustedShockIndexInterpretation.highRisk:
      case TraumaAdjustedShockIndexInterpretation.veryHighRisk:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSiAbnormal =
        result.shockIndexInterpretation != ShockIndexInterpretation.normal;
    final isTasiAbnormal =
        result.tasiInterpretation != null &&
        result.tasiInterpretation !=
            TraumaAdjustedShockIndexInterpretation.lowRisk;

    return Column(
      children: [
        ResultCard(
          title: 'Input Values & Normal Ranges',
          child: Column(
            children: [
              ResultRow(
                label: 'Heart Rate',
                value: formatNumber(result.heartRate, decimals: 0),
                unit: 'bpm',
                isHighlighted: false,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Normal range: 60-100 bpm (adults at rest)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ),
              const Divider(),
              ResultRow(
                label: 'Systolic BP',
                value: formatNumber(result.systolicBp, decimals: 0),
                unit: 'mmHg',
                isHighlighted: false,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Normal range: 90-120 mmHg',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ResultCard(
          title: 'Shock Index (SI)',
          child: Column(
            children: [
              ResultRow(
                label: 'Shock Index',
                value: formatNumber(result.shockIndex, decimals: 2),
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Normal range: < 0.5',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getShockIndexIcon(),
                      color: _getShockIndexColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getShockIndexInterpretationText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getShockIndexColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSiAbnormal) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getShockIndexColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getShockIndexColor(), width: 1),
                  ),
                  child: Text(
                    'Elevated SI suggests possible hypovolemia, sepsis, or cardiogenic shock. Assess clinically and initiate appropriate resuscitation.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getShockIndexColor(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (result.traumaAdjustedShockIndex != null) ...[
          const SizedBox(height: 16),
          ResultCard(
            title: 'Trauma-Adjusted Shock Index (TASI)',
            child: Column(
              children: [
                ResultRow(
                  label: 'TASI',
                  value: formatNumber(
                    result.traumaAdjustedShockIndex!,
                    decimals: 2,
                  ),
                  isHighlighted: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Normal range: < 40',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Icon(_getTasiIcon(), color: _getTasiColor(), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getTasiInterpretationText(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _getTasiColor(),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isTasiAbnormal) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTasiColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getTasiColor(), width: 1),
                    ),
                    child: Text(
                      'Elevated TASI indicates increased risk of hemorrhagic shock or severe trauma. Early trauma team activation and aggressive resuscitation recommended.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: _getTasiColor()),
                    ),
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
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reduced Accuracy',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'SI and TASI may have reduced accuracy in:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '• Beta-blocker use\n'
                '• Pacemakers\n'
                '• Pregnancy\n'
                '• Pediatric patients (for TASI)\n'
                '• Neurogenic shock',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.orange.shade900),
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
                    'Formulas',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Shock Index (SI)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SI = HR ÷ SBP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade900,
                  fontFamily: 'monospace',
                ),
              ),
              if (result.traumaAdjustedShockIndex != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Trauma-Adjusted Shock Index (TASI)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'TASI = Age × SI',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade900,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
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
                  'SI and TASI are adjunct tools; interpret alongside clinical findings.',
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
