import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/renal_dose_adjustment/data/repositories/renal_dose_adjustment_repository_impl.dart';
import 'package:chemical_app/features/renal_dose_adjustment/domain/entities/renal_dose_adjustment_result.dart';

/// Repository provider
final renalDoseAdjustmentRepositoryProvider =
    Provider<RenalDoseAdjustmentRepositoryImpl>((ref) {
  return RenalDoseAdjustmentRepositoryImpl();
});

/// Form state
class RenalDoseAdjustmentFormState {
  final String? age;
  final bool? isMale;
  final String? weightKg;
  final String? serumCreatinine;
  final String? standardDose;

  const RenalDoseAdjustmentFormState({
    this.age,
    this.isMale,
    this.weightKg,
    this.serumCreatinine,
    this.standardDose,
  });

  RenalDoseAdjustmentFormState copyWith({
    String? age,
    bool? isMale,
    String? weightKg,
    String? serumCreatinine,
    String? standardDose,
  }) {
    return RenalDoseAdjustmentFormState(
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      weightKg: weightKg ?? this.weightKg,
      serumCreatinine: serumCreatinine ?? this.serumCreatinine,
      standardDose: standardDose ?? this.standardDose,
    );
  }

  bool get isValid {
    if (age == null ||
        age!.isEmpty ||
        isMale == null ||
        weightKg == null ||
        weightKg!.isEmpty ||
        serumCreatinine == null ||
        serumCreatinine!.isEmpty ||
        standardDose == null ||
        standardDose!.isEmpty) {
      return false;
    }

    final ageValue = int.tryParse(age!);
    final weight = double.tryParse(weightKg!);
    final creatinine = double.tryParse(serumCreatinine!);
    final dose = double.tryParse(standardDose!);

    if (ageValue == null || weight == null || creatinine == null || dose == null) {
      return false;
    }

    // Validate ranges
    if (ageValue < 0 || ageValue > 120) {
      return false;
    }
    if (weight <= 0) {
      return false;
    }
    if (creatinine <= 0) {
      return false;
    }
    if (dose <= 0) {
      return false;
    }

    return true;
  }
}

/// Form state notifier
class RenalDoseAdjustmentFormNotifier
    extends StateNotifier<RenalDoseAdjustmentFormState> {
  RenalDoseAdjustmentFormNotifier() : super(const RenalDoseAdjustmentFormState());

  void setAge(String? age) {
    state = state.copyWith(age: age);
  }

  void setIsMale(bool? isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setSerumCreatinine(String? serumCreatinine) {
    state = state.copyWith(serumCreatinine: serumCreatinine);
  }

  void setStandardDose(String? standardDose) {
    state = state.copyWith(standardDose: standardDose);
  }

  void reset() {
    state = const RenalDoseAdjustmentFormState();
  }
}

final renalDoseAdjustmentFormProvider =
    StateNotifierProvider<RenalDoseAdjustmentFormNotifier,
        RenalDoseAdjustmentFormState>((ref) {
  return RenalDoseAdjustmentFormNotifier();
});

/// Calculation result provider
final renalDoseAdjustmentResultProvider =
    Provider.autoDispose<RenalDoseAdjustmentResult?>((ref) {
  final formState = ref.watch(renalDoseAdjustmentFormProvider);
  final repository = ref.watch(renalDoseAdjustmentRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final age = int.parse(formState.age!);
    final isMale = formState.isMale!;
    final weightKg = double.parse(formState.weightKg!);
    final serumCreatinine = double.parse(formState.serumCreatinine!);
    final standardDose = double.parse(formState.standardDose!);

    return repository.calculate(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinineUmolPerL: serumCreatinine,
      standardDose: standardDose,
    );
  } catch (e) {
    return null;
  }
});
