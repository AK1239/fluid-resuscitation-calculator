/// Entity representing maintenance fluid calculation result
class MaintenanceFluidResult {
  final double dailyTotal; // Daily total in mL
  final double hourlyRate; // Hourly rate in mL/hr
  final String additionalInfo; // Display-only additional information

  const MaintenanceFluidResult({
    required this.dailyTotal,
    required this.hourlyRate,
    required this.additionalInfo,
  });
}

