import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/map_pulse_pressure/domain/entities/map_pulse_pressure_result.dart';

class MapPulsePressureResultWidget extends StatelessWidget {
  final MapPulsePressureResult result;

  const MapPulsePressureResultWidget({super.key, required this.result});

  String _getPulsePressureInterpretationText() {
    switch (result.pulsePressureInterpretation) {
      case PulsePressureInterpretation.narrow:
        return 'Narrow pulse pressure – consider low stroke volume (e.g., shock, tamponade)';
      case PulsePressureInterpretation.normal:
        return 'Normal pulse pressure';
      case PulsePressureInterpretation.wide:
        return 'Wide pulse pressure – consider aortic regurgitation, sepsis, anemia';
    }
  }

  String _getMapInterpretationText() {
    switch (result.mapInterpretation) {
      case MapInterpretation.low:
        return 'Low MAP – inadequate organ perfusion';
      case MapInterpretation.borderline:
        return 'Borderline MAP';
      case MapInterpretation.adequate:
        return 'Adequate MAP for organ perfusion';
    }
  }

  Color _getPulsePressureColor() {
    switch (result.pulsePressureInterpretation) {
      case PulsePressureInterpretation.narrow:
      case PulsePressureInterpretation.wide:
        return Colors.red;
      case PulsePressureInterpretation.normal:
        return Colors.green;
    }
  }

  Color _getMapColor() {
    switch (result.mapInterpretation) {
      case MapInterpretation.low:
        return Colors.red;
      case MapInterpretation.borderline:
        return Colors.orange;
      case MapInterpretation.adequate:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPulsePressureAbnormal =
        result.pulsePressureInterpretation !=
        PulsePressureInterpretation.normal;
    final isMapAbnormal =
        result.mapInterpretation == MapInterpretation.low ||
        result.mapInterpretation == MapInterpretation.borderline;

    return Column(
      children: [
        ResultCard(
          title: 'Calculation Results',
          child: Column(
            children: [
              ResultRow(
                label: 'Pulse Pressure',
                value: formatNumber(result.pulsePressure, decimals: 1),
                unit: 'mmHg',
                isHighlighted: true,
              ),
              if (isPulsePressureAbnormal)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: _getPulsePressureColor(),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getPulsePressureInterpretationText(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _getPulsePressureColor(),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (result.pulsePressureInterpretation ==
                          PulsePressureInterpretation.wide) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getPulsePressureColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getPulsePressureColor(),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Possible Causes of Wide Pulse Pressure:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getPulsePressureColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '• Aortic regurgitation\n'
                                '• Sepsis / Systemic inflammatory response\n'
                                '• Anemia\n'
                                '• Hyperthyroidism\n'
                                '• Arteriovenous fistula\n'
                                '• Fever / Hyperdynamic states',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getPulsePressureColor(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: _getPulsePressureColor(),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getPulsePressureInterpretationText(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _getPulsePressureColor(),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              ResultRow(
                label: 'Mean Arterial Pressure',
                value: formatNumber(result.meanArterialPressure, decimals: 1),
                unit: 'mmHg',
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isMapAbnormal
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          color: _getMapColor(),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getMapInterpretationText(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getMapColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (result.mapInterpretation == MapInterpretation.low) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getMapColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getMapColor(),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Possible Causes of Low MAP:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getMapColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• Hypovolemia / Hemorrhage\n'
                              '• Cardiogenic shock\n'
                              '• Distributive shock (sepsis, anaphylaxis)\n'
                              '• Obstructive shock (PE, tamponade)\n'
                              '• Severe dehydration\n'
                              '• Medication effects (antihypertensives)',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getMapColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
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
                    'Formulas Used',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Pulse Pressure (PP)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'PP = SBP - DBP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade900,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mean Arterial Pressure (MAP)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'MAP = DBP + ⅓(SBP - DBP)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade900,
                  fontFamily: 'monospace',
                ),
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
