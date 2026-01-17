import 'package:chemical_app/features/premature_baby_fluid/domain/entities/premature_baby_fluid_result.dart';

/// Use case for calculating premature baby fluid requirements
class CalculatePrematureBabyFluid {
  /// Data matrix for baseline fluid requirements (ml/kg/day)
  static const Map<int, Map<GestationalCategory, double>> _baselineFluidMatrix = {
    0: {
      GestationalCategory.pretermLessThan1000g: 100,
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 80,
      GestationalCategory.termNeonate: 60,
    },
    1: {
      GestationalCategory.pretermLessThan1000g: 120,
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 100,
      GestationalCategory.termNeonate: 80,
    },
    2: {
      GestationalCategory.pretermLessThan1000g: 140,
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 120,
      GestationalCategory.termNeonate: 100,
    },
    3: {
      GestationalCategory.pretermLessThan1000g: 150,
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 140,
      GestationalCategory.termNeonate: 120,
    },
    4: {
      GestationalCategory.pretermLessThan1000g: 160,
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 160,
      GestationalCategory.termNeonate: 140,
    },
    5: {
      GestationalCategory.pretermLessThan1000g: 170, // Mid-range of 160-180
      GestationalCategory.pretermLessThan35wGreaterThan1000g: 170, // Mid-range of 160-180
      GestationalCategory.termNeonate: 155, // Mid-range of 150-160
    },
  };

  /// Gets baseline fluid requirement from matrix
  double _getBaselineFluidMlPerKgPerDay({
    required int dayOfLife,
    required GestationalCategory category,
  }) {
    // Day 6+ uses day 5 values (or day 5 range midpoints)
    final day = dayOfLife >= 6 ? 5 : dayOfLife;

    if (day == 5) {
      // Use mid-range values for day 5
      switch (category) {
        case GestationalCategory.pretermLessThan1000g:
          return 170; // Mid-range of 160-180
        case GestationalCategory.pretermLessThan35wGreaterThan1000g:
          return 170; // Mid-range of 160-180
        case GestationalCategory.termNeonate:
          return 155; // Mid-range of 150-160
      }
    }

    // Day 6+ specific values
    if (dayOfLife >= 6) {
      switch (category) {
        case GestationalCategory.pretermLessThan1000g:
          return 160;
        case GestationalCategory.pretermLessThan35wGreaterThan1000g:
          return 155; // Mid-range of 150-160
        case GestationalCategory.termNeonate:
          return 150;
      }
    }

    // Days 0-4 from matrix
    final dayMatrix = _baselineFluidMatrix[day];
    if (dayMatrix != null) {
      return dayMatrix[category] ?? 0;
    }

    return 0;
  }

  /// Calculates EBM volume in ml/kg/day
  double _calculateEbmMlPerKgPerDay({
    required bool canTakeEbm,
    required int dayOfLife,
  }) {
    if (!canTakeEbm) {
      return 0;
    }

    if (dayOfLife == 0) {
      return 0;
    } else if (dayOfLife == 1) {
      return 10;
    } else {
      // Day 2+: 10 + [(Day - 1) × 20]
      return 10 + ((dayOfLife - 1) * 20);
    }
  }

  /// Calculates enteral volume in ml/day
  double _calculateEnteralVolumeMlPerDay({
    required double ebmMlPerKgPerDay,
    required double birthWeightKg,
  }) {
    return ebmMlPerKgPerDay * birthWeightKg;
  }

  /// Determines clinical restriction percentage
  double _getClinicalRestrictionPercent({
    required bool hasSevereHie,
    required bool hasAki,
    required bool hasCerebralEdema,
    required bool hasMultiOrganDamage,
  }) {
    final hasAnyCondition = hasSevereHie ||
        hasAki ||
        hasCerebralEdema ||
        hasMultiOrganDamage;

    if (hasAnyCondition) {
      // Use mid-range: 15% (between 10-20%)
      return 15;
    }
    return 0;
  }

  /// Gets environmental increment in ml/kg/day
  double _getEnvironmentalIncrementMlPerKgPerDay(Environment environment) {
    switch (environment) {
      case Environment.none:
        return 0;
      case Environment.phototherapy:
        return 17.5; // Mid-range of 15-20
      case Environment.radiantWarmer:
        return 25; // Mid-range of 20-30
    }
  }

  /// Executes the calculation
  PrematureBabyFluidResult execute({
    required GestationalCategory gestationalCategory,
    required int dayOfLife,
    required double currentWeightKg,
    required bool canTakeEbm,
    required Environment environment,
    required bool hasSevereHie,
    required bool hasAki,
    required bool hasCerebralEdema,
    required bool hasMultiOrganDamage,
  }) {
    // 1. Get baseline fluid requirement
    final baselineFluidMlPerKgPerDay = _getBaselineFluidMlPerKgPerDay(
      dayOfLife: dayOfLife,
      category: gestationalCategory,
    );

    // 2. Calculate EBM volume
    final ebmMlPerKgPerDay = _calculateEbmMlPerKgPerDay(
      canTakeEbm: canTakeEbm,
      dayOfLife: dayOfLife,
    );

    // 3. Calculate enteral volume
    final enteralVolumeMlPerDay = _calculateEnteralVolumeMlPerDay(
      ebmMlPerKgPerDay: ebmMlPerKgPerDay,
      birthWeightKg: currentWeightKg,
    );

    // 4. Get adjustments
    final clinicalRestrictionPercent = _getClinicalRestrictionPercent(
      hasSevereHie: hasSevereHie,
      hasAki: hasAki,
      hasCerebralEdema: hasCerebralEdema,
      hasMultiOrganDamage: hasMultiOrganDamage,
    );

    final environmentalIncrementMlPerKgPerDay =
        _getEnvironmentalIncrementMlPerKgPerDay(environment);

    // 5. Calculate total adjusted fluid volume
    // Start with baseline
    var totalFluidMlPerKgPerDay = baselineFluidMlPerKgPerDay;

    // Apply clinical restriction (subtract percentage)
    if (clinicalRestrictionPercent > 0) {
      totalFluidMlPerKgPerDay =
          totalFluidMlPerKgPerDay * (1 - clinicalRestrictionPercent / 100);
    }

    // Add environmental increment
    totalFluidMlPerKgPerDay += environmentalIncrementMlPerKgPerDay;

    // Convert to total ml/day using current weight
    final totalAdjustedFluidMlPerDay =
        totalFluidMlPerKgPerDay * currentWeightKg;

    // 6. Calculate final IV fluid volume (subtract enteral feeds)
    final finalIvFluidVolumeMlPerDay =
        (totalAdjustedFluidMlPerDay - enteralVolumeMlPerDay).clamp(0.0, double.infinity);

    // 7. Calculate IV rate (ml/hour)
    final ivRateMlPerHour = finalIvFluidVolumeMlPerDay / 24;

    // 8. Determine fluid type
    final fluidType = dayOfLife == 0 ? FluidType.d10w : FluidType.d10_02ns;

    // 9. Build fluid composition description
    final fluidComposition = _getFluidComposition(fluidType);

    // 10. Build adjustments applied list
    final adjustmentsApplied = <String>[];
    if (clinicalRestrictionPercent > 0) {
      adjustmentsApplied.add(
        'Clinical restriction: -${clinicalRestrictionPercent.toStringAsFixed(0)}%',
      );
    }
    if (environmentalIncrementMlPerKgPerDay > 0) {
      adjustmentsApplied.add(
        'Environmental increment: +${environmentalIncrementMlPerKgPerDay.toStringAsFixed(1)} ml/kg/day',
      );
    }
    if (enteralVolumeMlPerDay > 0) {
      adjustmentsApplied.add(
        'Enteral feeding deduction: -${enteralVolumeMlPerDay.toStringAsFixed(0)} ml/day',
      );
    }
    if (adjustmentsApplied.isEmpty) {
      adjustmentsApplied.add('No adjustments applied');
    }

    // 11. Build safety notes
    final safetyNotes = <String>[];
    if (gestationalCategory == GestationalCategory.pretermLessThan1000g ||
        gestationalCategory == GestationalCategory.pretermLessThan35wGreaterThan1000g) {
      safetyNotes.add(
        'PDA Warning: Fluid overload increases the risk of Patent Ductus Arteriosus in premature infants.',
      );
      safetyNotes.add(
        'RDS Warning: Excessive fluids worsen Respiratory Distress Syndrome.',
      );
    }
    if (canTakeEbm) {
      safetyNotes.add(
        'Feeding Tip: Breast milk is preferred over formula whenever possible.',
      );
    }

    return PrematureBabyFluidResult(
      gestationalCategory: gestationalCategory,
      dayOfLife: dayOfLife,
      currentWeightKg: currentWeightKg,
      canTakeEbm: canTakeEbm,
      environment: environment,
      hasSevereHie: hasSevereHie,
      hasAki: hasAki,
      hasCerebralEdema: hasCerebralEdema,
      hasMultiOrganDamage: hasMultiOrganDamage,
      baselineFluidMlPerKgPerDay: baselineFluidMlPerKgPerDay,
      ebmMlPerKgPerDay: ebmMlPerKgPerDay,
      enteralVolumeMlPerDay: enteralVolumeMlPerDay,
      clinicalRestrictionPercent: clinicalRestrictionPercent,
      environmentalIncrementMlPerKgPerDay: environmentalIncrementMlPerKgPerDay,
      totalAdjustedFluidMlPerDay: totalAdjustedFluidMlPerDay,
      finalIvFluidVolumeMlPerDay: finalIvFluidVolumeMlPerDay,
      ivRateMlPerHour: ivRateMlPerHour,
      fluidType: fluidType,
      fluidComposition: fluidComposition,
      adjustmentsApplied: adjustmentsApplied,
      safetyNotes: safetyNotes,
    );
  }

  String _getFluidComposition(FluidType fluidType) {
    switch (fluidType) {
      case FluidType.d10w:
        return 'D10W (10% Dextrose in Water)';
      case FluidType.d10_02ns:
        return 'D10 0.2NS (10% Dextrose in ¼ Normal Saline)\n'
            'Mixing instructions per 100 mL:\n'
            '• 25 mL DNS\n'
            '• 10 mL D50W\n'
            '• 65 mL D5W\n'
            '\n'
            'Note: Avoid DNS or D10:NS in equal proportions due to high renal solute load in neonates.';
    }
  }
}