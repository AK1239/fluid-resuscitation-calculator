import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/electrolytes/sodium/data/repositories/sodium_repository_impl.dart';
import 'package:chemical_app/features/electrolytes/sodium/domain/entities/sodium_correction_result.dart';

/// Repository provider
final sodiumRepositoryProvider = Provider<SodiumRepositoryImpl>((ref) {
  return SodiumRepositoryImpl();
});

/// Form state
class SodiumFormState {
  final bool? isMale;
  final String? weight;
  final String? currentNa;
  final String? targetNa;

  const SodiumFormState({
    this.isMale,
    this.weight,
    this.currentNa,
    this.targetNa,
  });

  SodiumFormState copyWith({
    bool? isMale,
    String? weight,
    String? currentNa,
    String? targetNa,
  }) {
    return SodiumFormState(
      isMale: isMale ?? this.isMale,
      weight: weight ?? this.weight,
      currentNa: currentNa ?? this.currentNa,
      targetNa: targetNa ?? this.targetNa,
    );
  }

  bool get isValid {
    return isMale != null &&
        weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        currentNa != null &&
        currentNa!.isNotEmpty &&
        double.tryParse(currentNa!) != null &&
        targetNa != null &&
        targetNa!.isNotEmpty &&
        double.tryParse(targetNa!) != null;
  }
}

/// Form state notifier
class SodiumFormNotifier extends StateNotifier<SodiumFormState> {
  SodiumFormNotifier() : super(const SodiumFormState());

  void setIsMale(bool? isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setCurrentNa(String? currentNa) {
    state = state.copyWith(currentNa: currentNa);
  }

  void setTargetNa(String? targetNa) {
    state = state.copyWith(targetNa: targetNa);
  }

  void reset() {
    state = const SodiumFormState();
  }
}

final sodiumFormProvider =
    StateNotifierProvider<SodiumFormNotifier, SodiumFormState>((ref) {
  return SodiumFormNotifier();
});

/// Calculation result provider
final sodiumResultProvider =
    Provider.autoDispose<SodiumCorrectionResult?>((ref) {
  final formState = ref.watch(sodiumFormProvider);
  final repository = ref.watch(sodiumRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    final currentNa = double.parse(formState.currentNa!);
    final targetNa = double.parse(formState.targetNa!);
    return repository.calculate(
      isMale: formState.isMale!,
      weightKg: weight,
      currentNa: currentNa,
      targetNa: targetNa,
    );
  } catch (e) {
    return null;
  }
});

