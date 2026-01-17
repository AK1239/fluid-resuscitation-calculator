import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/core/utils/formatters.dart';
import 'package:chemical_app/features/egfr_calculator/domain/entities/egfr_result.dart';

class EgfrResultWidget extends StatelessWidget {
  final EgfrResult result;

  const EgfrResultWidget({super.key, required this.result});

  String _getCkdStageText() {
    switch (result.ckdStage) {
      case CkdStage.g1:
        return 'CKD G1 (≥ 90)';
      case CkdStage.g2:
        return 'CKD G2 (60–89)';
      case CkdStage.g3a:
        return 'CKD G3a (45–59)';
      case CkdStage.g3b:
        return 'CKD G3b (30–44)';
      case CkdStage.g4:
        return 'CKD G4 (15–29)';
      case CkdStage.g5:
        return 'CKD G5 (< 15)';
    }
  }

  String _getCkdStageDescription() {
    switch (result.ckdStage) {
      case CkdStage.g1:
        return 'Normal or high kidney function';
      case CkdStage.g2:
        return 'Mild decrease in kidney function';
      case CkdStage.g3a:
        return 'Mild-to-moderate decrease in kidney function';
      case CkdStage.g3b:
        return 'Moderate-to-severe decrease in kidney function';
      case CkdStage.g4:
        return 'Severe decrease in kidney function';
      case CkdStage.g5:
        return 'Kidney failure';
    }
  }

  String _getFormulaUsedText() {
    switch (result.formulaUsed) {
      case EgfrFormulaType.creatinineOnly:
        return 'CKD-EPI 2021 (Creatinine-only)';
      case EgfrFormulaType.cystatinCOnly:
        return 'CKD-EPI 2012 (Cystatin C-only)';
      case EgfrFormulaType.combined:
        return 'CKD-EPI 2012 (Combined Creatinine + Cystatin C) - Most Accurate';
    }
  }

  Color _getCkdStageColor() {
    switch (result.ckdStage) {
      case CkdStage.g1:
      case CkdStage.g2:
        return Colors.green;
      case CkdStage.g3a:
        return Colors.orange;
      case CkdStage.g3b:
        return Colors.red;
      case CkdStage.g4:
        return Colors.red.shade700;
      case CkdStage.g5:
        return Colors.red.shade900;
    }
  }

  IconData _getCkdStageIcon() {
    switch (result.ckdStage) {
      case CkdStage.g1:
      case CkdStage.g2:
        return Icons.check_circle_outline;
      case CkdStage.g3a:
      case CkdStage.g3b:
      case CkdStage.g4:
      case CkdStage.g5:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAbnormal = result.ckdStage != CkdStage.g1 && result.ckdStage != CkdStage.g2;

    return Column(
      children: [
        ResultCard(
          title: 'eGFR Calculation Results',
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
              if (result.cystatinC != null) ...[
                ResultRow(
                  label: 'Cystatin C',
                  value: formatNumber(result.cystatinC!, decimals: 2),
                  unit: 'mg/L',
                  isHighlighted: false,
                ),
              ],
              const Divider(),
              ResultRow(
                label: 'eGFR',
                value: formatNumber(result.egfr, decimals: 1),
                unit: 'mL/min/1.73 m²',
                isHighlighted: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getCkdStageIcon(),
                      color: _getCkdStageColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getCkdStageText(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: _getCkdStageColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getCkdStageDescription(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: _getCkdStageColor(),
                                ),
                          ),
                        ],
                      ),
                    ),
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
                    'Formula Used',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _getFormulaUsedText(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        if (isAbnormal) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCkdStageColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getCkdStageColor(),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCkdStageIcon(),
                      color: _getCkdStageColor(),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getCkdStageText(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getCkdStageColor(),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getCkdStageDescription(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _getCkdStageColor(),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (result.ckdStage == CkdStage.g5) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Consider nephrology consultation and preparation for renal replacement therapy.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getCkdStageColor(),
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
                  'eGFR is estimated using CKD-EPI equations. Classification based on KDIGO 2023 guidelines. This tool is for clinical support only.',
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
