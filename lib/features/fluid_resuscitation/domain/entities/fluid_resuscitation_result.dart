/// Entity representing fluid resuscitation calculation result
class FluidResuscitationResult {
  final double totalDeficit; // Total fluid deficit in mL
  final double phase1Volume; // ½ deficit over 30 minutes
  final double phase1Duration; // 30 minutes
  final double phase2DeficitVolume; // ¼ deficit
  final double phase2TotalVolume; // Maintenance + ¼ deficit
  final double phase2Duration; // 8 hours
  final double phase2HourlyRate; // Hourly rate for phase 2
  final double phase3DeficitVolume; // ¼ deficit
  final double phase3TotalVolume; // Maintenance + ¼ deficit
  final double phase3Duration; // 16 hours
  final double phase3HourlyRate; // Hourly rate for phase 3
  final double maintenanceFluidsPerDay; // Daily maintenance fluids

  const FluidResuscitationResult({
    required this.totalDeficit,
    required this.phase1Volume,
    required this.phase1Duration,
    required this.phase2DeficitVolume,
    required this.phase2TotalVolume,
    required this.phase2Duration,
    required this.phase2HourlyRate,
    required this.phase3DeficitVolume,
    required this.phase3TotalVolume,
    required this.phase3Duration,
    required this.phase3HourlyRate,
    required this.maintenanceFluidsPerDay,
  });
}

