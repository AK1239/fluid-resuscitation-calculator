/// Dehydration percentage ranges for adults and pediatrics
/// These ranges differ between adult and pediatric patients

enum PatientType { adult, pediatric }

enum DehydrationSeverity { mild, moderate, severe }

class DehydrationRange {
  final double minPercent;
  final double maxPercent;
  final String label;

  const DehydrationRange({
    required this.minPercent,
    required this.maxPercent,
    required this.label,
  });
}

/// Get dehydration percentage based on severity and patient type
double getDehydrationPercent({
  required PatientType patientType,
  required DehydrationSeverity severity,
}) {
  if (patientType == PatientType.adult) {
    switch (severity) {
      case DehydrationSeverity.mild:
        return 3.0; // 3-5% for adults
      case DehydrationSeverity.moderate:
        return 6.0; // 6-9% for adults
      case DehydrationSeverity.severe:
        return 10.0; // 10-15% for adults
    }
  } else {
    // Pediatric
    switch (severity) {
      case DehydrationSeverity.mild:
        return 3.0; // 3-5% for pediatrics
      case DehydrationSeverity.moderate:
        return 7.0; // 6-10% for pediatrics
      case DehydrationSeverity.severe:
        return 12.0; // 10-15% for pediatrics
    }
  }
}

/// Get dehydration ranges for display
List<DehydrationRange> getDehydrationRanges(PatientType patientType) {
  if (patientType == PatientType.adult) {
    return const [
      DehydrationRange(minPercent: 3.0, maxPercent: 5.0, label: 'Mild (3-5%)'),
      DehydrationRange(
        minPercent: 6.0,
        maxPercent: 9.0,
        label: 'Moderate (6-9%)',
      ),
      DehydrationRange(
        minPercent: 10.0,
        maxPercent: 15.0,
        label: 'Severe (10-15%)',
      ),
    ];
  } else {
    return const [
      DehydrationRange(minPercent: 3.0, maxPercent: 5.0, label: 'Mild (3-5%)'),
      DehydrationRange(
        minPercent: 6.0,
        maxPercent: 10.0,
        label: 'Moderate (6-10%)',
      ),
      DehydrationRange(
        minPercent: 10.0,
        maxPercent: 15.0,
        label: 'Severe (10-15%)',
      ),
    ];
  }
}
