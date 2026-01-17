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

  const RenalDoseAdjustmentFormState({
    this.age,
    this.isMale,
    this.weightKg,
    this.serumCreatinine,
  });

  RenalDoseAdjustmentFormState copyWith({
    String? age,
    bool? isMale,
    String? weightKg,
    String? serumCreatinine,
  }) {
    return RenalDoseAdjustmentFormState(
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      weightKg: weightKg ?? this.weightKg,
      serumCreatinine: serumCreatinine ?? this.serumCreatinine,
    );
  }

  bool get isValid {
    if (age == null ||
        age!.isEmpty ||
        isMale == null ||
        weightKg == null ||
        weightKg!.isEmpty ||
        serumCreatinine == null ||
        serumCreatinine!.isEmpty) {
      return false;
    }

    final ageValue = int.tryParse(age!);
    final weight = double.tryParse(weightKg!);
    final creatinine = double.tryParse(serumCreatinine!);

    if (ageValue == null || weight == null || creatinine == null) {
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

    return repository.calculate(
      age: age,
      isMale: isMale,
      weightKg: weightKg,
      serumCreatinineUmolPerL: serumCreatinine,
    );
  } catch (e) {
    return null;
  }
});
