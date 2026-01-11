import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/electrolytes/potassium/data/repositories/potassium_repository_impl.dart';
import 'package:chemical_app/features/electrolytes/potassium/domain/entities/potassium_correction_result.dart';

/// Repository provider
final potassiumRepositoryProvider = Provider<PotassiumRepositoryImpl>((ref) {
  return PotassiumRepositoryImpl();
});

/// Form state
class PotassiumFormState {
  final String? weight;
  final String? currentK;
  final String? targetK;

  const PotassiumFormState({
    this.weight,
    this.currentK,
    this.targetK,
  });

  PotassiumFormState copyWith({
    String? weight,
    String? currentK,
    String? targetK,
  }) {
    return PotassiumFormState(
      weight: weight ?? this.weight,
      currentK: currentK ?? this.currentK,
      targetK: targetK ?? this.targetK,
    );
  }

  bool get isValid {
    return weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        currentK != null &&
        currentK!.isNotEmpty &&
        double.tryParse(currentK!) != null &&
        targetK != null &&
        targetK!.isNotEmpty &&
        double.tryParse(targetK!) != null;
  }
}

/// Form state notifier
class PotassiumFormNotifier extends StateNotifier<PotassiumFormState> {
  PotassiumFormNotifier() : super(const PotassiumFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setCurrentK(String? currentK) {
    state = state.copyWith(currentK: currentK);
  }

  void setTargetK(String? targetK) {
    state = state.copyWith(targetK: targetK);
  }

  void reset() {
    state = const PotassiumFormState();
  }
}

final potassiumFormProvider =
    StateNotifierProvider<PotassiumFormNotifier, PotassiumFormState>((ref) {
  return PotassiumFormNotifier();
});

/// Calculation result provider
final potassiumResultProvider =
    Provider.autoDispose<PotassiumCorrectionResult?>((ref) {
  final formState = ref.watch(potassiumFormProvider);
  final repository = ref.watch(potassiumRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    final currentK = double.parse(formState.currentK!);
    final targetK = double.parse(formState.targetK!);
    return repository.calculate(
      weightKg: weight,
      currentK: currentK,
      targetK: targetK,
    );
  } catch (e) {
    return null;
  }
});

