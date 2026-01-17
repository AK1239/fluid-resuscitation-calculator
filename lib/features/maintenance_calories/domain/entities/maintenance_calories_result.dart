/// Entity representing maintenance calories calculation result
class MaintenanceCaloriesResult {
  final double weightKg;
  final PatientCategory category;
  final double kcalPerKgPerDay;
  final double totalDailyCalories;
  final double gramsDextrosePerDay;
  final double volumeDnsMl; // mL of DNS / 24 hours
  final double volumeD5Ml; // mL of D5 / 24 hours
  final double volumeD10Ml; // mL of D10 / 24 hours
  final double volumeD50Ml; // mL of D50 / 24 hours

  const MaintenanceCaloriesResult({
    required this.weightKg,
    required this.category,
    required this.kcalPerKgPerDay,
    required this.totalDailyCalories,
    required this.gramsDextrosePerDay,
    required this.volumeDnsMl,
    required this.volumeD5Ml,
    required this.volumeD10Ml,
    required this.volumeD50Ml,
  });
}

/// Patient category / clinical condition
enum PatientCategory {
  healthyAdultResting,
  mildIllnessOrStress,
  moderateToSevereIllness,
  severeTraumaBurnsSepsis,
  elderlyPatient,
  paralysisImmobilization,
  obesePatient,
  neonate,
}

/// Helper class for patient category ranges
class PatientCategoryRange {
  final PatientCategory category;
  final double minKcalPerKgPerDay;
  final double maxKcalPerKgPerDay;
  final String displayName;

  const PatientCategoryRange({
    required this.category,
    required this.minKcalPerKgPerDay,
    required this.maxKcalPerKgPerDay,
    required this.displayName,
  });

  double get midpointKcalPerKgPerDay {
    return (minKcalPerKgPerDay + maxKcalPerKgPerDay) / 2;
  }

  static const Map<PatientCategory, PatientCategoryRange> ranges = {
    PatientCategory.healthyAdultResting: PatientCategoryRange(
      category: PatientCategory.healthyAdultResting,
      minKcalPerKgPerDay: 20,
      maxKcalPerKgPerDay: 25,
      displayName: 'Healthy adult, resting',
    ),
    PatientCategory.mildIllnessOrStress: PatientCategoryRange(
      category: PatientCategory.mildIllnessOrStress,
      minKcalPerKgPerDay: 25,
      maxKcalPerKgPerDay: 30,
      displayName: 'Mild illness or stress',
    ),
    PatientCategory.moderateToSevereIllness: PatientCategoryRange(
      category: PatientCategory.moderateToSevereIllness,
      minKcalPerKgPerDay: 30,
      maxKcalPerKgPerDay: 35,
      displayName: 'Moderate to severe illness',
    ),
    PatientCategory.severeTraumaBurnsSepsis: PatientCategoryRange(
      category: PatientCategory.severeTraumaBurnsSepsis,
      minKcalPerKgPerDay: 35,
      maxKcalPerKgPerDay: 45,
      displayName: 'Severe trauma / burns / sepsis',
    ),
    PatientCategory.elderlyPatient: PatientCategoryRange(
      category: PatientCategory.elderlyPatient,
      minKcalPerKgPerDay: 20,
      maxKcalPerKgPerDay: 25,
      displayName: 'Elderly patient',
    ),
    PatientCategory.paralysisImmobilization: PatientCategoryRange(
      category: PatientCategory.paralysisImmobilization,
      minKcalPerKgPerDay: 15,
      maxKcalPerKgPerDay: 20,
      displayName: 'Paralysis / immobilization',
    ),
    PatientCategory.obesePatient: PatientCategoryRange(
      category: PatientCategory.obesePatient,
      minKcalPerKgPerDay: 11,
      maxKcalPerKgPerDay: 14,
      displayName: 'Obese patient (BMI >30)',
    ),
    PatientCategory.neonate: PatientCategoryRange(
      category: PatientCategory.neonate,
      minKcalPerKgPerDay: 80,
      maxKcalPerKgPerDay: 120,
      displayName: 'Neonate',
    ),
  };
}