/// Entity representing ATLS hemorrhagic shock classification result
class AtlsShockResult {
  final int? age;
  final double weightKg;
  final double systolicBp;
  final double diastolicBp;
  final double pulsePressure; // Auto-calculated
  final int respiratoryRate;
  final double? totalUrineVolume;
  final double? timeSinceCatheterHours;
  final double? urineOutputMlPerHr; // Auto-calculated
  final MentalStatus mentalStatus;
  final double? baseDeficit;
  final double? estimatedBloodLossPercent;
  final double? estimatedBloodLossMl;
  final AtlsShockClass shockClass;
  final List<String> parametersThatDroveEscalation;
  final String physiologicInterpretation;

  const AtlsShockResult({
    this.age,
    required this.weightKg,
    required this.systolicBp,
    required this.diastolicBp,
    required this.pulsePressure,
    required this.respiratoryRate,
    this.totalUrineVolume,
    this.timeSinceCatheterHours,
    this.urineOutputMlPerHr,
    required this.mentalStatus,
    this.baseDeficit,
    this.estimatedBloodLossPercent,
    this.estimatedBloodLossMl,
    required this.shockClass,
    required this.parametersThatDroveEscalation,
    required this.physiologicInterpretation,
  });
}

/// ATLS Hemorrhagic Shock Class
enum AtlsShockClass {
  class1, // Mild
  class2, // Moderate
  class3, // Severe
  class4, // Life-threatening
}

/// Mental status options
enum MentalStatus {
  normal,
  slightlyAnxious,
  mildlyAnxious,
  anxiousConfused,
  confusedLethargic,
}
