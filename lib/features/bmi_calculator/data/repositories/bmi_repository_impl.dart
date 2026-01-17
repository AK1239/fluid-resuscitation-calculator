import 'package:chemical_app/features/bmi_calculator/domain/entities/bmi_result.dart';
import 'package:chemical_app/features/bmi_calculator/domain/use_cases/calculate_bmi.dart';

/// Repository implementation for BMI calculation
class BmiRepositoryImpl {
  final CalculateBmi _calculateBmi;

  BmiRepositoryImpl({
    CalculateBmi? calculateBmi,
  }) : _calculateBmi = calculateBmi ?? CalculateBmi();

  /// Calculates BMI
  BmiResult calculate({
    required double weightValue,
    required String weightUnit,
    required double heightValue,
    int? heightInches,
    required String heightUnit,
  }) {
    return _calculateBmi.execute(
      weightValue: weightValue,
      weightUnit: weightUnit,
      heightValue: heightValue,
      heightInches: heightInches,
      heightUnit: heightUnit,
    );
  }
}