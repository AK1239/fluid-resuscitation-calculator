import 'package:chemical_app/features/iron_sucrose/domain/entities/iron_sucrose_result.dart';

/// Use case for calculating iron sucrose dosing using Ganzoni formula
class CalculateIronSucrose {
  /// Calculates iron sucrose dosing using Ganzoni formula
  /// Formula: Total iron deficit = Weight × (Target Hb - Actual Hb) × 2.4 + Iron stores
  IronSucroseResult execute({
    required double weightKg,
    required bool isMale,
    required double actualHb,
    double? targetHb,
    bool includeIronStores = true,
  }) {
    // Determine target Hb (default: 13 g/dL for men, 12 g/dL for women)
    final targetHbValue = targetHb ?? (isMale ? 13.0 : 12.0);

    // Step 1: Calculate Hb deficit
    final hbDeficit = targetHbValue - actualHb;

    // Step 2: Calculate iron deficit from Hb (Weight × Hb deficit × 2.4)
    final ironDeficitFromHb = weightKg * hbDeficit * 2.4;

    // Step 3: Add iron stores if included (500 mg for adults)
    final ironStores = includeIronStores ? 500.0 : 0.0;

    // Step 4: Calculate total iron deficit
    final totalIronDeficit = ironDeficitFromHb + ironStores;

    // Calculate number of doses (each dose is 200 mg, maximum single dose)
    const maxSingleDose = 200.0; // mg
    final numberOfDoses = (totalIronDeficit / maxSingleDose).ceil();

    // Calculate total volume (iron sucrose contains 20 mg elemental iron per mL)
    const ironConcentrationMgPerMl = 20.0; // mg/mL
    final totalVolume = totalIronDeficit / ironConcentrationMgPerMl;

    return IronSucroseResult(
      weightKg: weightKg,
      isMale: isMale,
      actualHb: actualHb,
      targetHb: targetHbValue,
      includeIronStores: includeIronStores,
      hbDeficit: hbDeficit,
      ironDeficitFromHb: ironDeficitFromHb,
      ironStores: ironStores,
      totalIronDeficit: totalIronDeficit,
      numberOfDoses: numberOfDoses,
      totalVolume: totalVolume,
    );
  }
}
