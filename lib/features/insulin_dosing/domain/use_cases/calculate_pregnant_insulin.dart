import 'package:chemical_app/features/insulin_dosing/domain/entities/pregnant_insulin_result.dart';

/// Use case for calculating insulin dosing during pregnancy
class CalculatePregnantInsulin {
  /// Calculates initial insulin dosing during pregnancy
  PregnantInsulinResult execute({
    required double maternalWeightKg,
    required String trimester, // "1st", "2nd", "3rd"
    required String obesityClass, // "None", "Class II", "Class III"
    required String
    currentRegimen, // "None", "Basal-bolus", "Four-injection regimen"
    required Set<String> glucosePatterns, // Set of selected patterns
  }) {
    // Step 1: Calculate TDD based on trimester and obesity
    final tdd = _calculateTDD(maternalWeightKg, trimester, obesityClass);

    // Step 2: Determine if four-injection regimen is required
    final requiresFourInjection = _requiresFourInjectionRegimen(
      glucosePatterns,
    );

    // Step 3: Calculate dosing based on regimen
    final adjustments = <String>[];
    final injectionSchedule = <InjectionDose>[];

    double? morningNph;
    double? morningRapidActing;
    double? morningBasal;
    double? morningRapidActingFourInjection;
    double? dinnerRapidActing;
    double? bedtimeBasal;
    double? lunchRapidActing;

    if (requiresFourInjection || currentRegimen == "Four-injection regimen") {
      // Four-injection regimen
      final morningTotal = (tdd * 2 / 3); // 2/3 of TDD
      morningBasal = (morningTotal * 2 / 3); // 2/3 of morning dose as basal
      morningRapidActingFourInjection =
          (morningTotal * 1 / 3); // 1/3 of morning dose as rapid-acting

      final eveningTotal = (tdd * 1 / 3); // 1/3 of TDD
      dinnerRapidActing = (eveningTotal * 1 / 2); // 1/2 of evening dose
      bedtimeBasal = (eveningTotal * 1 / 2); // 1/2 of evening dose as basal

      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast",
          insulinType: "NPH (basal)",
          units: morningBasal,
          rationale: "2/3 of morning dose (2/3 of TDD)",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: morningRapidActingFourInjection,
          rationale: "1/3 of morning dose",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before dinner",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: dinnerRapidActing,
          rationale: "1/2 of evening dose (1/3 of TDD)",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Bedtime",
          insulinType: "NPH or Long-acting (glargine)",
          units: bedtimeBasal,
          rationale: "1/2 of evening dose",
        ),
      );

      // Optional lunch insulin if post-lunch hyperglycemia
      if (glucosePatterns.contains("Elevated post-lunch glucose")) {
        lunchRapidActing = 6.0; // Starting dose
        injectionSchedule.add(
          InjectionDose(
            timing: "Before lunch",
            insulinType: "Rapid-acting (lispro/aspart)",
            units: lunchRapidActing,
            rationale: "Post-lunch hyperglycemia",
          ),
        );
        adjustments.add(
          "Add 6-10 units rapid-acting insulin before lunch for post-lunch hyperglycemia",
        );
      }
    } else if (currentRegimen == "None" || currentRegimen == "Basal-bolus") {
      // Standard initial regimen (mild-moderate hyperglycemia)
      morningNph = 15.0; // Starting point: 10-20 units
      morningRapidActing = 8.0; // Starting point: 6-10 units

      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast",
          insulinType: "NPH (basal)",
          units: morningNph,
          rationale: "Starting dose: 10-20 units",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: morningRapidActing,
          rationale: "Starting dose: 6-10 units",
        ),
      );

      adjustments.add(
        "Doses are starting points and will be titrated based on glucose patterns",
      );
    }

    // Apply adjustment rules based on glucose patterns
    _applyAdjustmentRules(
      glucosePatterns,
      adjustments,
      injectionSchedule,
      morningNph,
      morningRapidActing,
      dinnerRapidActing,
      lunchRapidActing,
      bedtimeBasal,
      maternalWeightKg,
    );

    return PregnantInsulinResult(
      maternalWeightKg: maternalWeightKg,
      trimester: trimester,
      obesityClass: obesityClass,
      currentRegimen: currentRegimen,
      totalDailyDose: tdd,
      requiresFourInjectionRegimen: requiresFourInjection,
      morningNph: morningNph,
      morningRapidActing: morningRapidActing,
      morningBasal: morningBasal,
      morningRapidActingFourInjection: morningRapidActingFourInjection,
      dinnerRapidActing: dinnerRapidActing,
      bedtimeBasal: bedtimeBasal,
      lunchRapidActing: lunchRapidActing,
      adjustments: adjustments,
      injectionSchedule: injectionSchedule,
    );
  }

  /// Calculates TDD based on trimester and obesity
  double _calculateTDD(double weightKg, String trimester, String obesityClass) {
    double unitsPerKg;

    // Base calculation by trimester
    if (trimester == "2nd") {
      unitsPerKg = 0.9;
    } else if (trimester == "3rd") {
      unitsPerKg = 1.0;
    } else {
      // 1st trimester: use general range midpoint (0.7-2.0)
      unitsPerKg = 0.85;
    }

    // Adjust for obesity
    if (obesityClass == "Class II" || obesityClass == "Class III") {
      unitsPerKg = 1.75; // Midpoint of 1.5-2.0 range
    }

    return weightKg * unitsPerKg;
  }

  /// Determines if four-injection regimen is required
  bool _requiresFourInjectionRegimen(Set<String> glucosePatterns) {
    return glucosePatterns.contains(
          "Both preprandial and postprandial glucose elevated",
        ) ||
        glucosePatterns.contains(
          "Postprandial control only achievable with starvation ketosis",
        );
  }

  /// Applies adjustment rules based on glucose patterns
  void _applyAdjustmentRules(
    Set<String> glucosePatterns,
    List<String> adjustments,
    List<InjectionDose> injectionSchedule,
    double? morningNph,
    double? morningRapidActing,
    double? dinnerRapidActing,
    double? lunchRapidActing,
    double? bedtimeBasal,
    double maternalWeightKg,
  ) {
    // A. Postprandial hyperglycemia - increase rapid-acting by 10-20%
    if (glucosePatterns.contains("Elevated post-breakfast glucose")) {
      adjustments.add(
        "Increase morning rapid-acting insulin by 10-20% for post-breakfast hyperglycemia",
      );
    }
    if (glucosePatterns.contains("Elevated post-lunch glucose") &&
        lunchRapidActing == null) {
      adjustments.add(
        "Add 6-10 units rapid-acting insulin before lunch for post-lunch hyperglycemia",
      );
    }
    if (glucosePatterns.contains("Elevated post-dinner glucose")) {
      adjustments.add(
        "Increase dinner rapid-acting insulin by 10-20% for post-dinner hyperglycemia",
      );
    }

    // B. Isolated post-meal elevations
    if (glucosePatterns.contains("Elevated post-dinner glucose") &&
        !glucosePatterns.contains("Elevated fasting glucose") &&
        !glucosePatterns.contains("Elevated post-breakfast glucose") &&
        !glucosePatterns.contains("Elevated post-lunch glucose")) {
      adjustments.add(
        "Add 6-10 units rapid-acting insulin before dinner for isolated post-dinner elevation",
      );
    }

    if (glucosePatterns.contains("Elevated post-breakfast glucose") &&
        glucosePatterns.contains("Elevated post-lunch glucose") &&
        morningNph != null) {
      adjustments.add(
        "Increase morning NPH dose for elevated post-breakfast and post-lunch glucose",
      );
    }

    // C. Elevated fasting glucose (postprandials controlled)
    if (glucosePatterns.contains("Elevated fasting glucose") &&
        !glucosePatterns.contains("Elevated post-breakfast glucose") &&
        !glucosePatterns.contains("Elevated post-lunch glucose") &&
        !glucosePatterns.contains("Elevated post-dinner glucose") &&
        bedtimeBasal == null) {
      final bedtimeDose = 0.2 * maternalWeightKg; // 0.2 units/kg
      adjustments.add(
        "Add basal insulin at bedtime: ${bedtimeDose.toStringAsFixed(1)} units (0.2 units/kg). Options: NPH or Long-acting (glargine)",
      );
    }
  }
}
