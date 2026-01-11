import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_assessment_result.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/use_cases/assess_who_growth.dart';

/// Repository implementation for WHO growth assessment
class WhoGrowthRepositoryImpl {
  final AssessWhoGrowth _assessWhoGrowth;

  WhoGrowthRepositoryImpl({
    AssessWhoGrowth? assessWhoGrowth,
  }) : _assessWhoGrowth = assessWhoGrowth ?? AssessWhoGrowth();

  /// Assesses child growth using WHO Z-scores
  WhoGrowthAssessmentResult assess({
    required int ageMonths,
    required bool isMale,
    required double weightKg,
    required double heightCm,
    required double waz,
    required double haz,
    required double whz,
  }) {
    return _assessWhoGrowth.execute(
      ageMonths: ageMonths,
      isMale: isMale,
      weightKg: weightKg,
      heightCm: heightCm,
      waz: waz,
      haz: haz,
      whz: whz,
    );
  }
}
