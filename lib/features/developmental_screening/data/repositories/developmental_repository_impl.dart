import 'package:chemical_app/features/developmental_screening/domain/entities/developmental_assessment_result.dart';
import 'package:chemical_app/features/developmental_screening/domain/use_cases/assess_development.dart';

/// Repository implementation for developmental screening
class DevelopmentalRepositoryImpl {
  final AssessDevelopment _assessDevelopment;

  DevelopmentalRepositoryImpl({
    AssessDevelopment? assessDevelopment,
  }) : _assessDevelopment = assessDevelopment ?? AssessDevelopment();

  /// Assesses child development
  DevelopmentalAssessmentResult assess({
    required int ageMonths,
    bool isCorrectedAge = false,
    int? correctedAgeMonths,
    required Map<DevelopmentalDomain, DomainClassification> domainClassifications,
  }) {
    return _assessDevelopment.execute(
      ageMonths: ageMonths,
      isCorrectedAge: isCorrectedAge,
      correctedAgeMonths: correctedAgeMonths,
      domainClassifications: domainClassifications,
    );
  }
}
