import 'package:chemical_app/features/bmi_calculator/domain/entities/bmi_result.dart';

/// Use case for calculating BMI
class CalculateBmi {
  /// Converts pounds to kilograms
  /// Conversion factor: 1 kg = 2.2046 lb
  double _convertPoundsToKilograms(double pounds) {
    return pounds / 2.2046;
  }

  /// Converts centimeters to meters
  double _convertCentimetersToMeters(double centimeters) {
    return centimeters / 100;
  }

  /// Converts feet and inches to meters
  /// 1 foot = 0.3048 meters, 1 inch = 0.0254 meters
  double _convertFeetInchesToMeters(int feet, int inches) {
    final totalInches = (feet * 12) + inches;
    return totalInches * 0.0254;
  }

  /// Calculates BMI
  /// Formula: BMI = weight (kg) ÷ [height (m)]²
  double _calculateBmi({
    required double weightKg,
    required double heightM,
  }) {
    if (heightM <= 0) {
      throw ArgumentError('Height must be greater than 0');
    }

    final bmi = weightKg / (heightM * heightM);
    
    // Round to 1 decimal place
    return (bmi * 10).roundToDouble() / 10;
  }

  /// Determines BMI category based on WHO classification
  BmiCategory _determineBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return BmiCategory.underweight;
    } else if (bmi < 25.0) {
      return BmiCategory.normalWeight;
    } else if (bmi < 30.0) {
      return BmiCategory.overweight;
    } else if (bmi < 35.0) {
      return BmiCategory.obesityClass1;
    } else if (bmi < 40.0) {
      return BmiCategory.obesityClass2;
    } else {
      return BmiCategory.obesityClass3;
    }
  }

  /// Gets BMI interpretation based on category
  String _getBmiInterpretation(double bmi, BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the underweight range. This may indicate nutritional deficiencies or underlying health conditions.';
      case BmiCategory.normalWeight:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the normal weight range. This is generally associated with lower risk of obesity-related complications.';
      case BmiCategory.overweight:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the overweight range. Consider lifestyle modifications to reduce cardiovascular risk.';
      case BmiCategory.obesityClass1:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the Obesity Class I range (30.0-34.9). This is associated with increased risk of cardiovascular disease and other obesity-related complications.';
      case BmiCategory.obesityClass2:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the Obesity Class II range (35.0-39.9). This is associated with significantly increased risk of obesity-related complications.';
      case BmiCategory.obesityClass3:
        return 'Your BMI is ${bmi.toStringAsFixed(1)} kg/m², which falls within the Obesity Class III range (≥40.0). This is associated with severe obesity-related health risks and may require medical intervention.';
    }
  }

  /// Executes the BMI calculation
  /// [weightValue] - weight value in the specified unit
  /// [weightUnit] - 'kg' or 'lb'
  /// [heightValue] - height value (single value for cm/m, or feet for ft/in)
  /// [heightInches] - inches value (only used when heightUnit is 'ft/in')
  /// [heightUnit] - 'cm', 'm', or 'ft/in'
  BmiResult execute({
    required double weightValue,
    required String weightUnit,
    required double heightValue,
    int? heightInches,
    required String heightUnit,
  }) {
    // Convert weight to kilograms
    double weightKg;
    if (weightUnit == 'kg') {
      weightKg = weightValue;
    } else if (weightUnit == 'lb') {
      weightKg = _convertPoundsToKilograms(weightValue);
    } else {
      throw ArgumentError('Invalid weight unit: $weightUnit');
    }

    // Convert height to meters
    double heightM;
    if (heightUnit == 'm') {
      heightM = heightValue;
    } else if (heightUnit == 'cm') {
      heightM = _convertCentimetersToMeters(heightValue);
    } else if (heightUnit == 'ft/in') {
      if (heightInches == null) {
        throw ArgumentError('Height in inches is required when using ft/in unit');
      }
      heightM = _convertFeetInchesToMeters(heightValue.toInt(), heightInches);
    } else {
      throw ArgumentError('Invalid height unit: $heightUnit');
    }

    // Calculate BMI
    final bmi = _calculateBmi(weightKg: weightKg, heightM: heightM);

    // Determine category
    final category = _determineBmiCategory(bmi);

    // Get interpretation
    final interpretation = _getBmiInterpretation(bmi, category);

    return BmiResult(
      weightKg: weightKg,
      heightM: heightM,
      bmi: bmi,
      category: category,
      interpretation: interpretation,
    );
  }
}