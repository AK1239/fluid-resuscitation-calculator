/// Entity representing iron sucrose calculation result
class IronSucroseResult {
  final double weightKg;
  final bool isMale;
  final double actualHb;
  final double targetHb;
  final bool includeIronStores;
  final double hbDeficit; // Target Hb - Actual Hb
  final double ironDeficitFromHb; // Weight × Hb deficit × 2.4
  final double ironStores; // 500 mg if included, 0 otherwise
  final double totalIronDeficit; // Total iron required
  final int numberOfDoses; // Number of 200 mg doses needed
  final double totalVolume; // Total volume of iron sucrose (mL)

  const IronSucroseResult({
    required this.weightKg,
    required this.isMale,
    required this.actualHb,
    required this.targetHb,
    required this.includeIronStores,
    required this.hbDeficit,
    required this.ironDeficitFromHb,
    required this.ironStores,
    required this.totalIronDeficit,
    required this.numberOfDoses,
    required this.totalVolume,
  });
}
