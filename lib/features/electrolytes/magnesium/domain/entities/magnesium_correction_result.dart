/// Entity representing magnesium correction calculation result
class MagnesiumCorrectionResult {
  final String suggestedDosing; // Suggested IV dosing ranges
  final String expectedSerumRise; // Expected serum rise
  final String monitoringReminders; // Monitoring reminders

  const MagnesiumCorrectionResult({
    required this.suggestedDosing,
    required this.expectedSerumRise,
    required this.monitoringReminders,
  });
}

