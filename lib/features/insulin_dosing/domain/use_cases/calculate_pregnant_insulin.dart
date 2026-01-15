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
    // Step 1: Determine if four-injection regimen is required
    final requiresFourInjection = _requiresFourInjectionRegimen(
      glucosePatterns,
      currentRegimen,
    );

    // Step 2: Calculate TDD only for four-injection regimen
    final tdd = requiresFourInjection
        ? _calculateTDDForFourInjection(
            maternalWeightKg,
            trimester,
            obesityClass,
          )
        : 0.0; // Not used for initial regimen

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

    if (requiresFourInjection) {
      // Four-injection regimen
      // Two-thirds of TDD in morning
      final morningTotal = (tdd * 2 / 3);
      // Two-thirds of morning dose as basal, one-third as rapid-acting
      morningBasal = (morningTotal * 2 / 3);
      morningRapidActingFourInjection = (morningTotal * 1 / 3);

      // One-third of TDD in evening
      final eveningTotal = (tdd * 1 / 3);
      // Half as rapid-acting before dinner, half as basal at bedtime
      dinnerRapidActing = (eveningTotal * 1 / 2);
      bedtimeBasal = (eveningTotal * 1 / 2);

      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast (up to 15 min before)",
          insulinType: "NPH (basal)",
          units: morningBasal,
          rationale: "2/3 of morning dose (2/3 of TDD)",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast (up to 15 min before)",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: morningRapidActingFourInjection,
          rationale: "1/3 of morning dose",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before dinner (up to 15 min before)",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: dinnerRapidActing,
          rationale: "1/2 of evening dose (1/3 of TDD)",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Bedtime (or before dinner if individualized)",
          insulinType: "NPH or Long-acting (glargine)",
          units: bedtimeBasal,
          rationale: "1/2 of evening dose",
        ),
      );

      // Optional lunch insulin if post-lunch hyperglycemia persists
      if (glucosePatterns.contains("Elevated post-lunch glucose")) {
        lunchRapidActing = 8.0; // Starting dose: 6-10 units (using midpoint)
        injectionSchedule.add(
          InjectionDose(
            timing: "Before lunch (up to 15 min before)",
            insulinType: "Rapid-acting (lispro/aspart)",
            units: lunchRapidActing,
            rationale: "Post-lunch hyperglycemia persists",
          ),
        );
        adjustments.add(
          "Add 6-10 units rapid-acting insulin before lunch if post-lunch hyperglycemia persists",
        );
      }
    } else {
      // Standard initial regimen: single injection in morning
      // 10-20 units NPH + 6-10 units rapid-acting before breakfast
      morningNph = 15.0; // Midpoint of 10-20 units
      morningRapidActing = 8.0; // Midpoint of 6-10 units

      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast (immediately before)",
          insulinType: "NPH (intermediate-acting basal)",
          units: morningNph,
          rationale: "Starting dose: 10-20 units",
        ),
      );
      injectionSchedule.add(
        InjectionDose(
          timing: "Before breakfast (immediately before)",
          insulinType: "Rapid-acting (lispro/aspart)",
          units: morningRapidActing,
          rationale: "Starting dose: 6-10 units",
        ),
      );

      // Add bedtime basal if fasting glucose is elevated (postprandials controlled)
      if (glucosePatterns.contains("Elevated fasting glucose") &&
          !glucosePatterns.contains("Elevated post-breakfast glucose") &&
          !glucosePatterns.contains("Elevated post-lunch glucose") &&
          !glucosePatterns.contains("Elevated post-dinner glucose")) {
        bedtimeBasal = 0.2 * maternalWeightKg; // 0.2 units/kg
        injectionSchedule.add(
          InjectionDose(
            timing: "Bedtime (preferably, or with dinner if individualized)",
            insulinType: "NPH or Long-acting (glargine)",
            units: bedtimeBasal,
            rationale:
                "Initial dose: 0.2 units/kg (fasting glucose elevated, postprandials controlled)",
          ),
        );
        adjustments.add(
          "If fasting glucose is elevated after postprandial levels are in target range, add intermediate-acting basal insulin. Long-acting insulin analog (glargine) may be used instead of NPH",
        );
      }
    }

    // Apply adjustment rules based on glucose patterns (only for initial regimen)
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
      requiresFourInjection,
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

  /// Calculates TDD for four-injection regimen based on trimester and obesity
  double _calculateTDDForFourInjection(
    double weightKg,
    String trimester,
    String obesityClass,
  ) {
    double unitsPerKg;

    // Adjust for obesity first (overrides trimester calculation)
    if (obesityClass == "Class II" || obesityClass == "Class III") {
      // 1.5-2.0 units/kg for Class II/III obesity
      unitsPerKg = 1.75; // Midpoint of 1.5-2.0 range
    } else {
      // Base calculation by trimester (only for four-injection regimen)
      if (trimester == "2nd") {
        unitsPerKg = 0.9;
      } else if (trimester == "3rd") {
        unitsPerKg = 1.0;
      } else {
        // 1st trimester: use 2nd trimester value as default
        unitsPerKg = 0.9;
      }
    }

    return weightKg * unitsPerKg;
  }

  /// Determines if four-injection regimen is required
  bool _requiresFourInjectionRegimen(
    Set<String> glucosePatterns,
    String currentRegimen,
  ) {
    // If already on four-injection regimen, continue with it
    if (currentRegimen == "Four-injection regimen") {
      return true;
    }

    // Indications for four-injection regimen:
    // 1. Both preprandial and postprandial glucose elevated
    // 2. Postprandial control only achievable with starvation ketosis
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
    bool isFourInjectionRegimen,
  ) {
    // Only apply adjustments for initial regimen (not four-injection)
    if (isFourInjectionRegimen) {
      return;
    }

    // Check if postprandial glucose remains high throughout the day
    // (multiple postprandial elevations, but not the specific combinations below)
    final hasPostBreakfast = glucosePatterns.contains(
      "Elevated post-breakfast glucose",
    );
    final hasPostLunch = glucosePatterns.contains(
      "Elevated post-lunch glucose",
    );
    final hasPostDinner = glucosePatterns.contains(
      "Elevated post-dinner glucose",
    );
    final hasFasting = glucosePatterns.contains("Elevated fasting glucose");

    final postprandialCount =
        (hasPostBreakfast ? 1 : 0) +
        (hasPostLunch ? 1 : 0) +
        (hasPostDinner ? 1 : 0);

    // Priority order: Check specific combinations first, then general cases

    // B1. Both post-breakfast and post-lunch elevated (highest priority for this combination)
    if (hasPostBreakfast &&
        hasPostLunch &&
        !hasPostDinner &&
        morningNph != null) {
      adjustments.add(
        "If both post-breakfast and post-lunch glucose levels are elevated, increasing the morning NPH may be sufficient",
      );
      return; // Don't check other cases if this applies
    }

    // B2. Isolated post-meal elevations
    // Only post-dinner elevated
    if (hasPostDinner &&
        !hasFasting &&
        !hasPostBreakfast &&
        !hasPostLunch &&
        dinnerRapidActing == null) {
      adjustments.add(
        "If only post-dinner glucose remains elevated, add 6-10 units rapid-acting insulin immediately before dinner",
      );
    }

    // Only post-lunch elevated
    if (hasPostLunch &&
        !hasFasting &&
        !hasPostBreakfast &&
        !hasPostDinner &&
        lunchRapidActing == null) {
      adjustments.add(
        "If only post-lunch glucose remains elevated, add 6-10 units rapid-acting insulin immediately before lunch",
      );
    }

    // Only post-breakfast elevated
    if (hasPostBreakfast &&
        !hasFasting &&
        !hasPostLunch &&
        !hasPostDinner &&
        morningRapidActing != null) {
      adjustments.add(
        "If only post-breakfast glucose remains elevated, increase morning rapid-acting insulin by 10-20%",
      );
    }

    // A. If postprandial glucose levels throughout the day remain high (multiple elevations)
    // This applies when there are 2+ postprandial elevations but not the specific combinations above
    if (postprandialCount >= 2 &&
        !(hasPostBreakfast && hasPostLunch && !hasPostDinner)) {
      adjustments.add(
        "If postprandial glucose levels throughout the day remain high, adjustments in the rapid-acting insulin dose are typically in the range of 10 to 20 percent",
      );
    }

    // C. Elevated fasting glucose (postprandials controlled)
    // This should add the actual injection to the schedule, not just an adjustment
    // Note: This is handled in the main execute method to add to injection schedule
  }
}
