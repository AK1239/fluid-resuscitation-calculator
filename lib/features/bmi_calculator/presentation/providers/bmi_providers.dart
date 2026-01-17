import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/bmi_calculator/data/repositories/bmi_repository_impl.dart';
import 'package:chemical_app/features/bmi_calculator/domain/entities/bmi_result.dart';

/// Repository provider
final bmiRepositoryProvider = Provider<BmiRepositoryImpl>((ref) {
  return BmiRepositoryImpl();
});

/// Form state
class BmiFormState {
  final String? weight;
  final String? weightUnit; // 'kg' or 'lb'
  final String? height;
  final String? heightInches; // Only used when heightUnit is 'ft/in'
  final String? heightUnit; // 'cm', 'm', or 'ft/in'

  const BmiFormState({
    this.weight,
    this.weightUnit,
    this.height,
    this.heightInches,
    this.heightUnit,
  });

  BmiFormState copyWith({
    String? weight,
    String? weightUnit,
    String? height,
    String? heightInches,
    String? heightUnit,
  }) {
    return BmiFormState(
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      height: height ?? this.height,
      heightInches: heightInches ?? this.heightInches,
      heightUnit: heightUnit ?? this.heightUnit,
    );
  }

  bool get isValid {
    if (weight == null ||
        weight!.isEmpty ||
        weightUnit == null ||
        height == null ||
        height!.isEmpty ||
        heightUnit == null) {
      return false;
    }

    final weightValue = double.tryParse(weight!);
    final heightValue = double.tryParse(height!);

    if (weightValue == null || heightValue == null) {
      return false;
    }

    // Validate ranges
    if (weightValue <= 0 || weightValue > 500) {
      return false;
    }
    if (heightValue <= 0) {
      return false;
    }

    // If height unit is ft/in, heightInches is required
    if (heightUnit == 'ft/in') {
      if (heightInches == null || heightInches!.isEmpty) {
        return false;
      }
      final inches = int.tryParse(heightInches!);
      if (inches == null || inches < 0 || inches >= 12) {
        return false;
      }
      if (heightValue.toInt() < 0 || heightValue.toInt() > 8) {
        return false;
      }
    } else {
      // For cm and m, validate reasonable ranges
      if (heightUnit == 'cm' && heightValue > 250) {
        return false;
      }
      if (heightUnit == 'm' && heightValue > 2.5) {
        return false;
      }
    }

    return true;
  }
}

/// Form state notifier
class BmiFormNotifier extends StateNotifier<BmiFormState> {
  BmiFormNotifier() : super(const BmiFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setWeightUnit(String? weightUnit) {
    state = state.copyWith(weightUnit: weightUnit);
  }

  void setHeight(String? height) {
    state = state.copyWith(height: height);
  }

  void setHeightInches(String? heightInches) {
    state = state.copyWith(heightInches: heightInches);
  }

  void setHeightUnit(String? heightUnit) {
    state = state.copyWith(heightUnit: heightUnit);
    // Clear heightInches when switching away from ft/in
    if (heightUnit != 'ft/in') {
      state = state.copyWith(heightInches: null);
    }
  }

  void reset() {
    state = const BmiFormState();
  }
}

final bmiFormProvider =
    StateNotifierProvider<BmiFormNotifier, BmiFormState>((ref) {
  return BmiFormNotifier();
});

/// Calculation result provider
final bmiResultProvider = Provider.autoDispose<BmiResult?>((ref) {
  final formState = ref.watch(bmiFormProvider);
  final repository = ref.watch(bmiRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weightValue = double.parse(formState.weight!);
    final heightValue = double.parse(formState.height!);
    final heightInches = formState.heightInches != null
        ? int.parse(formState.heightInches!)
        : null;

    return repository.calculate(
      weightValue: weightValue,
      weightUnit: formState.weightUnit!,
      heightValue: heightValue,
      heightInches: heightInches,
      heightUnit: formState.heightUnit!,
    );
  } catch (e) {
    return null;
  }
});