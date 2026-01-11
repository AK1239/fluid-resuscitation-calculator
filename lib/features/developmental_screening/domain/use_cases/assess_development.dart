import 'package:chemical_app/features/developmental_screening/domain/entities/developmental_assessment_result.dart';

/// Use case for developmental screening assessment
class AssessDevelopment {
  /// Assesses child development based on age and domain classifications
  DevelopmentalAssessmentResult execute({
    required int ageMonths,
    bool isCorrectedAge = false,
    int? correctedAgeMonths,
    required Map<DevelopmentalDomain, DomainClassification> domainClassifications,
  }) {
    // Use corrected age if applicable (for prematurity <2 years)
    final assessmentAgeMonths = (isCorrectedAge && correctedAgeMonths != null && ageMonths < 24)
        ? correctedAgeMonths
        : ageMonths;

    // Check for red flags based on age and classifications
    final redFlags = <String>[];
    _checkRedFlags(assessmentAgeMonths, domainClassifications, redFlags);

    // Determine overall status
    final overallStatus = _determineOverallStatus(domainClassifications, redFlags);

    // Generate domain assessment text
    final domainAssessment = _generateDomainAssessment(domainClassifications);

    // Generate guidance
    final guidance = _generateGuidance(overallStatus, domainClassifications, redFlags);

    // Safety note
    const safetyNote =
        'This tool is a screening aid and does not replace professional developmental assessment.';

    return DevelopmentalAssessmentResult(
      ageMonths: ageMonths,
      isCorrectedAge: isCorrectedAge,
      correctedAgeMonths: assessmentAgeMonths,
      domainClassifications: domainClassifications,
      overallStatus: overallStatus,
      redFlags: redFlags,
      domainAssessment: domainAssessment,
      guidance: guidance,
      safetyNote: safetyNote,
    );
  }

  /// Checks for red flags based on age and classifications
  void _checkRedFlags(
    int ageMonths,
    Map<DevelopmentalDomain, DomainClassification> classifications,
    List<String> redFlags,
  ) {
    // No social smile by 3 months
    if (ageMonths >= 3) {
      final socialEmotional = classifications[DevelopmentalDomain.socialEmotional];
      if (socialEmotional == DomainClassification.delayed ||
          socialEmotional == DomainClassification.borderline) {
        if (ageMonths == 3) {
          redFlags.add('No social smile by 3 months');
        }
      }
    }

    // No head control by 4 months
    if (ageMonths >= 4) {
      final grossMotor = classifications[DevelopmentalDomain.grossMotor];
      if (grossMotor == DomainClassification.delayed) {
        if (ageMonths == 4) {
          redFlags.add('No head control by 4 months');
        }
      }
    }

    // No babbling by 9 months
    if (ageMonths >= 9) {
      final language = classifications[DevelopmentalDomain.languageVocal];
      if (language == DomainClassification.delayed) {
        if (ageMonths == 9) {
          redFlags.add('No babbling by 9 months');
        }
      }
    }

    // No single words by 16 months
    if (ageMonths >= 16) {
      final language = classifications[DevelopmentalDomain.languageVocal];
      if (language == DomainClassification.delayed) {
        if (ageMonths == 16) {
          redFlags.add('No single words by 16 months');
        }
      }
    }

    // No two-word phrases by 24 months
    if (ageMonths >= 24) {
      final language = classifications[DevelopmentalDomain.languageVocal];
      if (language == DomainClassification.delayed) {
        if (ageMonths == 24) {
          redFlags.add('No two-word phrases by 24 months');
        }
      }
    }

    // Poor eye contact or lack of shared attention (if cognitive/social delayed)
    if (ageMonths >= 6) {
      final social = classifications[DevelopmentalDomain.socialEmotional];
      final cognitive = classifications[DevelopmentalDomain.cognitiveVision];
      if ((social == DomainClassification.delayed ||
              cognitive == DomainClassification.delayed) &&
          ageMonths <= 12) {
        redFlags.add('Poor eye contact or lack of shared attention');
      }
    }
  }

  /// Determines overall developmental status
  OverallDevelopmentalStatus _determineOverallStatus(
    Map<DevelopmentalDomain, DomainClassification> classifications,
    List<String> redFlags,
  ) {
    if (redFlags.isNotEmpty) {
      return OverallDevelopmentalStatus.highRisk;
    }

    final delayedCount = classifications.values
        .where((classification) => classification == DomainClassification.delayed)
        .length;

    if (delayedCount > 0) {
      return OverallDevelopmentalStatus.possibleDelay;
    }

    return OverallDevelopmentalStatus.appropriate;
  }

  /// Generates domain assessment text
  String _generateDomainAssessment(
    Map<DevelopmentalDomain, DomainClassification> classifications,
  ) {
    final assessments = <String>[];
    for (final entry in classifications.entries) {
      assessments.add('${entry.key.label}: ${entry.value.label}');
    }
    return assessments.join('\n');
  }

  /// Generates guidance
  String _generateGuidance(
    OverallDevelopmentalStatus status,
    Map<DevelopmentalDomain, DomainClassification> classifications,
    List<String> redFlags,
  ) {
    if (status == OverallDevelopmentalStatus.highRisk) {
      return 'RED FLAG PATTERN DETECTED: Immediate referral for formal developmental evaluation is recommended. Early intervention services should be considered.';
    }

    if (status == OverallDevelopmentalStatus.possibleDelay) {
      final delayedDomains = classifications.entries
          .where((entry) => entry.value == DomainClassification.delayed)
          .map((entry) => entry.key.label)
          .toList();

      return 'Possible developmental delay detected in: ${delayedDomains.join(', ')}. Recommend formal developmental evaluation and early intervention referral. Re-screen in 3 months.';
    }

    final borderlineDomains = classifications.entries
        .where((entry) => entry.value == DomainClassification.borderline)
        .map((entry) => entry.key.label)
        .toList();

    if (borderlineDomains.isNotEmpty) {
      return 'Some areas are emerging (${borderlineDomains.join(', ')}). Continue stimulation activities. Re-screen in 3 months to monitor progress.';
    }

    return 'All developmental domains appear appropriate for age. Continue age-appropriate stimulation activities and routine developmental monitoring.';
  }
}
