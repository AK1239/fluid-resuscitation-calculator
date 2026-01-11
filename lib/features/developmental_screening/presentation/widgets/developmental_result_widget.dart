import 'package:flutter/material.dart';
import 'package:chemical_app/core/widgets/result_card.dart';
import 'package:chemical_app/features/developmental_screening/domain/entities/developmental_assessment_result.dart';

class DevelopmentalResultWidget extends StatelessWidget {
  final DevelopmentalAssessmentResult result;

  const DevelopmentalResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age Summary
        ResultCard(
          title: 'Age Summary',
          child: Column(
            children: [
              ResultRow(
                label: 'Chronological age',
                value: '${result.ageMonths} months',
                isHighlighted: false,
              ),
              if (result.isCorrectedAge) ...[
                ResultRow(
                  label: 'Corrected age (used for assessment)',
                  value: '${result.correctedAgeMonths} months',
                  isHighlighted: true,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Domain-Based Assessment
        ResultCard(
          title: 'Domain-Based Assessment',
          child: Column(
            children: result.domainClassifications.entries.map((entry) {
              final isDelayed = entry.value == DomainClassification.delayed;
              final isBorderline = entry.value == DomainClassification.borderline;
              return ResultRow(
                label: entry.key.label,
                value: entry.value.label,
                isHighlighted: isDelayed || isBorderline,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Overall Developmental Status
        ResultCard(
          title: 'Overall Developmental Status',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(context, result.overallStatus)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(result.overallStatus),
                  color: _getStatusColor(context, result.overallStatus),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.overallStatus.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(context, result.overallStatus),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (result.redFlags.isNotEmpty) ...[
          const SizedBox(height: 16),
          ResultCard(
            title: 'Red Flags Detected',
            backgroundColor: Colors.red.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: result.redFlags.map((flag) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          flag,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 16),
        // Guidance
        ResultCard(
          title: 'Guidance',
          child: Text(
            result.guidance,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        // Safety Note
        ResultCard(
          title: 'Safety Note',
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            result.safetyNote,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(
    BuildContext context,
    OverallDevelopmentalStatus status,
  ) {
    switch (status) {
      case OverallDevelopmentalStatus.appropriate:
        return Colors.green;
      case OverallDevelopmentalStatus.possibleDelay:
        return Colors.orange;
      case OverallDevelopmentalStatus.highRisk:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OverallDevelopmentalStatus status) {
    switch (status) {
      case OverallDevelopmentalStatus.appropriate:
        return Icons.check_circle;
      case OverallDevelopmentalStatus.possibleDelay:
        return Icons.warning;
      case OverallDevelopmentalStatus.highRisk:
        return Icons.error;
    }
  }
}
