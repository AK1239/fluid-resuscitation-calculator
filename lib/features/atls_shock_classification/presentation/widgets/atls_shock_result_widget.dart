import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/atls_shock_classification/domain/entities/atls_shock_result.dart';

class AtlsShockResultWidget extends StatelessWidget {
  final AtlsShockResult result;

  const AtlsShockResultWidget({super.key, required this.result});

  String _getShockClassText() {
    switch (result.shockClass) {
      case AtlsShockClass.class1:
        return 'Class I';
      case AtlsShockClass.class2:
        return 'Class II';
      case AtlsShockClass.class3:
        return 'Class III';
      case AtlsShockClass.class4:
        return 'Class IV';
    }
  }

  String _getSeverityLabel() {
    switch (result.shockClass) {
      case AtlsShockClass.class1:
        return 'Mild';
      case AtlsShockClass.class2:
        return 'Moderate';
      case AtlsShockClass.class3:
        return 'Severe';
      case AtlsShockClass.class4:
        return 'Life-threatening';
    }
  }

  String _getFluidStrategy() {
    switch (result.shockClass) {
      case AtlsShockClass.class1:
        return 'Crystalloid';
      case AtlsShockClass.class2:
        return 'Crystalloid';
      case AtlsShockClass.class3:
        return 'Crystalloid + Type-specific blood';
      case AtlsShockClass.class4:
        return 'Crystalloid + Massive transfusion protocol';
    }
  }

  Color _getShockClassColor() {
    switch (result.shockClass) {
      case AtlsShockClass.class1:
        return Colors.green;
      case AtlsShockClass.class2:
        return Colors.yellow.shade700;
      case AtlsShockClass.class3:
        return Colors.orange;
      case AtlsShockClass.class4:
        return Colors.red.shade900;
    }
  }

  IconData _getShockClassIcon() {
    switch (result.shockClass) {
      case AtlsShockClass.class1:
        return Icons.check_circle_outline;
      case AtlsShockClass.class2:
      case AtlsShockClass.class3:
      case AtlsShockClass.class4:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSevere =
        result.shockClass == AtlsShockClass.class3 ||
        result.shockClass == AtlsShockClass.class4;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _getShockClassColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _getShockClassColor(), width: 3),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getShockClassIcon(),
                    color: _getShockClassColor(),
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATLS ${_getShockClassText()}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getShockClassColor(),
                            ),
                      ),
                      Text(
                        _getSeverityLabel(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _getShockClassColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ResultCard(
          title: 'Derived Parameters',
          child: Column(
            children: [
              ResultRow(
                label: 'Pulse Pressure',
                value: formatNumber(result.pulsePressure, decimals: 0),
                unit: 'mmHg',
                isHighlighted: true,
              ),
              if (result.urineOutputMlPerHr != null) ...[
                ResultRow(
                  label: 'Urine Output',
                  value: formatNumber(result.urineOutputMlPerHr!, decimals: 1),
                  unit: 'mL/hr',
                  isHighlighted: true,
                ),
              ],
            ],
          ),
        ),
        if (result.parametersThatDroveEscalation.isNotEmpty) ...[
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
                      'Parameters That Drove Classification',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.parametersThatDroveEscalation.map(
                  (param) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $param',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
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
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: Colors.purple.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Physiologic Interpretation',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.physiologicInterpretation,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.purple.shade900),
              ),
            ],
          ),
        ),
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
                    Icons.medical_services,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Initial ATLS Fluid Strategy',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Educational guidance only',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _getFluidStrategy(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isSevere) ...[
                const SizedBox(height: 8),
                Text(
                  '• Monitor closely for signs of decompensation\n'
                  '• Urgent hemorrhage control indicated\n'
                  '• Consider blood products early\n'
                  '• Prepare for potential massive transfusion',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade900,
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
                  'This tool supports clinical reasoning but does not replace ATLS-trained provider judgment.',
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
