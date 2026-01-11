import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/electrolytes/calcium/data/repositories/calcium_repository_impl.dart';
import 'package:chemical_app/features/electrolytes/calcium/domain/entities/calcium_correction_result.dart';

/// Repository provider
final calciumRepositoryProvider = Provider<CalciumRepositoryImpl>((ref) {
  return CalciumRepositoryImpl();
});

/// Form state
class CalciumFormState {
  final String? weight;
  final String? currentCa;
  final bool? isSymptomatic;

  const CalciumFormState({
    this.weight,
    this.currentCa,
    this.isSymptomatic,
  });

  CalciumFormState copyWith({
    String? weight,
    String? currentCa,
    bool? isSymptomatic,
  }) {
    return CalciumFormState(
      weight: weight ?? this.weight,
      currentCa: currentCa ?? this.currentCa,
      isSymptomatic: isSymptomatic ?? this.isSymptomatic,
    );
  }

  bool get isValid {
    return weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        currentCa != null &&
        currentCa!.isNotEmpty &&
        double.tryParse(currentCa!) != null &&
        isSymptomatic != null;
  }
}

/// Form state notifier
class CalciumFormNotifier extends StateNotifier<CalciumFormState> {
  CalciumFormNotifier() : super(const CalciumFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setCurrentCa(String? currentCa) {
    state = state.copyWith(currentCa: currentCa);
  }

  void setIsSymptomatic(bool? isSymptomatic) {
    state = state.copyWith(isSymptomatic: isSymptomatic);
  }

  void reset() {
    state = const CalciumFormState();
  }
}

final calciumFormProvider =
    StateNotifierProvider<CalciumFormNotifier, CalciumFormState>((ref) {
  return CalciumFormNotifier();
});

/// Calculation result provider
final calciumResultProvider =
    Provider.autoDispose<CalciumCorrectionResult?>((ref) {
  final formState = ref.watch(calciumFormProvider);
  final repository = ref.watch(calciumRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    final currentCa = double.parse(formState.currentCa!);
    return repository.calculate(
      weightKg: weight,
      currentCa: currentCa,
      isSymptomatic: formState.isSymptomatic!,
    );
  } catch (e) {
    return null;
  }
});

