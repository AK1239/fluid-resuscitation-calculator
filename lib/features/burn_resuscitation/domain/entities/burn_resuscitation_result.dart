/// Entity representing burn resuscitation calculation result
class BurnResuscitationResult {
  final int ageYears;
  final double weightKg;
  final double tbsaPercent;
  final int timeSinceBurnHours;
  final bool hasInhalationInjury;
  final bool hasUrineOutputAvailable;
  final bool meetsIndication; // Whether patient meets indication for fluid resuscitation
  final double totalFluid24h; // Total fluid required over 24 hours (mL)
  final double first8hVolume; // Volume for first 8 hours (mL)
  final int first8hRemainingHours; // Remaining hours in first 8-hour period
  final double first8hHourlyRate; // Hourly rate for remaining first 8 hours (mL/hr)
  final double next16hVolume; // Volume for next 16 hours (mL)
  final double next16hHourlyRate; // Hourly rate for next 16 hours (mL/hr)
  final double urineOutputTarget; // Target urine output (mL/kg/hr)

  const BurnResuscitationResult({
    required this.ageYears,
    required this.weightKg,
    required this.tbsaPercent,
    required this.timeSinceBurnHours,
    required this.hasInhalationInjury,
    required this.hasUrineOutputAvailable,
    required this.meetsIndication,
    required this.totalFluid24h,
    required this.first8hVolume,
    required this.first8hRemainingHours,
    required this.first8hHourlyRate,
    required this.next16hVolume,
    required this.next16hHourlyRate,
    required this.urineOutputTarget,
  });
}
