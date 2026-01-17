/// Entity representing BMI calculation result
class BmiResult {
  final double weightKg; // Weight in kilograms (converted if needed)
  final double heightM; // Height in meters (converted if needed)
  final double bmi; // BMI value (rounded to 1 decimal place)
  final BmiCategory category;
  final String interpretation;

  const BmiResult({
    required this.weightKg,
    required this.heightM,
    required this.bmi,
    required this.category,
    required this.interpretation,
  });
}

/// BMI category based on WHO classification
enum BmiCategory {
  underweight, // < 18.5
  normalWeight, // 18.5 - 24.9
  overweight, // 25.0 - 29.9
  obesityClass1, // 30.0 - 34.9
  obesityClass2, // 35.0 - 39.9
  obesityClass3, // ≥ 40.0
}