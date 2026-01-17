import 'package:chemical_app/features/maintenance_calories/domain/entities/maintenance_calories_result.dart';

/// Use case for calculating maintenance calories
class CalculateMaintenanceCalories {
  // Constants
  static const double kcalPerGramDextrose = 3.4; // 1 g dextrose = 3.4 kcal
  static const double gramsDextrosePerLDns = 50.0; // DNS: 1 L = 50 g dextrose
  static const double gramsDextrosePerLD5 = 50.0; // D5: 1 L = 50 g dextrose
  static const double gramsDextrosePerLD10 = 100.0; // D10: 1 L = 100 g dextrose
  static const double gramsDextrosePerLD50 = 500.0; // D50: 1 L = 500 g dextrose

  /// Rounds a number to the nearest 10
  double _roundToNearest10(double value) {
    return (value / 10).round() * 10.0;
  }

  /// Executes the maintenance calories calculation
  MaintenanceCaloriesResult execute({
    required double weightKg,
    required PatientCategory category,
    required double kcalPerKgPerDay,
  }) {
    // Calculate total daily calories
    final totalDailyCalories = weightKg * kcalPerKgPerDay;

    // Convert calories to grams of dextrose
    final gramsDextrosePerDay = totalDailyCalories / kcalPerGramDextrose;

    // Calculate volume for each solution (in liters, then convert to mL)
    final volumeDnsL = gramsDextrosePerDay / gramsDextrosePerLDns;
    final volumeD5L = gramsDextrosePerDay / gramsDextrosePerLD5;
    final volumeD10L = gramsDextrosePerDay / gramsDextrosePerLD10;
    final volumeD50L = gramsDextrosePerDay / gramsDextrosePerLD50;

    // Convert liters to milliliters
    final volumeDnsMl = volumeDnsL * 1000;
    final volumeD5Ml = volumeD5L * 1000;
    final volumeD10Ml = volumeD10L * 1000;
    final volumeD50Ml = volumeD50L * 1000;

    // Round to nearest 10 mL
    final roundedVolumeDnsMl = _roundToNearest10(volumeDnsMl);
    final roundedVolumeD5Ml = _roundToNearest10(volumeD5Ml);
    final roundedVolumeD10Ml = _roundToNearest10(volumeD10Ml);
    final roundedVolumeD50Ml = _roundToNearest10(volumeD50Ml);

    return MaintenanceCaloriesResult(
      weightKg: weightKg,
      category: category,
      kcalPerKgPerDay: kcalPerKgPerDay,
      totalDailyCalories: totalDailyCalories,
      gramsDextrosePerDay: gramsDextrosePerDay,
      volumeDnsMl: roundedVolumeDnsMl,
      volumeD5Ml: roundedVolumeD5Ml,
      volumeD10Ml: roundedVolumeD10Ml,
      volumeD50Ml: roundedVolumeD50Ml,
    );
  }
}
