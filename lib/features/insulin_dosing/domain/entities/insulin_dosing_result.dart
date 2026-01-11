/// Entity representing insulin dosing calculation result
class InsulinDosingResult {
  final double totalDailyDose; // TDD in units
  final double morningDoseTotal; // Morning dose total in units
  final double morningInsoluble; // Morning NPH in units
  final double morningSoluble; // Morning Regular in units
  final double eveningDoseTotal; // Evening dose total in units
  final double eveningInsoluble; // Evening NPH in units
  final double eveningSoluble; // Evening Regular in units

  const InsulinDosingResult({
    required this.totalDailyDose,
    required this.morningDoseTotal,
    required this.morningInsoluble,
    required this.morningSoluble,
    required this.eveningDoseTotal,
    required this.eveningInsoluble,
    required this.eveningSoluble,
  });
}
