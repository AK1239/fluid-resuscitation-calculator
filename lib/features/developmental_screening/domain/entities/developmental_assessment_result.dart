/// Entity representing developmental assessment result
class DevelopmentalAssessmentResult {
  final int ageMonths;
  final bool isCorrectedAge; // For prematurity correction
  final int correctedAgeMonths;
  final Map<DevelopmentalDomain, DomainClassification> domainClassifications;
  final OverallDevelopmentalStatus overallStatus;
  final List<String> redFlags;
  final String domainAssessment;
  final String guidance;
  final String safetyNote;

  const DevelopmentalAssessmentResult({
    required this.ageMonths,
    required this.isCorrectedAge,
    required this.correctedAgeMonths,
    required this.domainClassifications,
    required this.overallStatus,
    required this.redFlags,
    required this.domainAssessment,
    required this.guidance,
    required this.safetyNote,
  });
}

/// Developmental domains
enum DevelopmentalDomain {
  grossMotor('Gross Motor'),
  fineMotor('Fine Motor'),
  languageVocal('Language/Vocal'),
  socialEmotional('Social/Emotional'),
  cognitiveVision('Cognitive/Vision'),
  reflexes('Reflexes');

  final String label;
  const DevelopmentalDomain(this.label);
}

/// Domain classification
enum DomainClassification {
  appropriate('Appropriate for age'),
  borderline('Borderline / Emerging'),
  delayed('Delayed');

  final String label;
  const DomainClassification(this.label);
}

/// Overall developmental status
enum OverallDevelopmentalStatus {
  appropriate('Development appropriate for age'),
  possibleDelay('Possible developmental delay'),
  highRisk('High-risk / Red-flag pattern');

  final String label;
  const OverallDevelopmentalStatus(this.label);
}
