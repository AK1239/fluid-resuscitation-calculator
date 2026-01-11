import 'package:chemical_app/features/iron_sucrose/domain/entities/iron_sucrose_result.dart';
import 'package:chemical_app/features/iron_sucrose/domain/use_cases/calculate_iron_sucrose.dart';

/// Repository implementation for iron sucrose calculations
class IronSucroseRepositoryImpl {
  final CalculateIronSucrose _calculateIronSucrose;

  IronSucroseRepositoryImpl({
    CalculateIronSucrose? calculateIronSucrose,
  }) : _calculateIronSucrose =
            calculateIronSucrose ?? CalculateIronSucrose();

  /// Calculates iron sucrose dosing using Ganzoni formula
  IronSucroseResult calculate({
    required double weightKg,
    required bool isMale,
    required double actualHb,
    double? targetHb,
    bool includeIronStores = true,
  }) {
    return _calculateIronSucrose.execute(
      weightKg: weightKg,
      isMale: isMale,
      actualHb: actualHb,
      targetHb: targetHb,
      includeIronStores: includeIronStores,
    );
  }
}
