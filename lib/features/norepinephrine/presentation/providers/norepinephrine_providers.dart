import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/norepinephrine/data/repositories/norepinephrine_repository_impl.dart';
import 'package:chemical_app/features/norepinephrine/domain/entities/norepinephrine_result.dart';

/// Repository provider
final norepinephrineRepositoryProvider =
    Provider<NorepinephrineRepositoryImpl>((ref) {
  return NorepinephrineRepositoryImpl();
});

/// Form state
class NorepinephrineFormState {
  final String? weight;
  final String? dose;

  const NorepinephrineFormState({
    this.weight,
    this.dose,
  });

  NorepinephrineFormState copyWith({
    String? weight,
    String? dose,
  }) {
    return NorepinephrineFormState(
      weight: weight ?? this.weight,
      dose: dose ?? this.dose,
    );
  }

  bool get isValid {
    return weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        double.parse(weight!) > 0 &&
        dose != null &&
        dose!.isNotEmpty &&
        double.tryParse(dose!) != null &&
        double.parse(dose!) > 0;
  }
}

/// Form state notifier
class NorepinephrineFormNotifier extends StateNotifier<NorepinephrineFormState> {
  NorepinephrineFormNotifier() : super(const NorepinephrineFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setDose(String? dose) {
    state = state.copyWith(dose: dose);
  }

  void reset() {
    state = const NorepinephrineFormState();
  }
}

final norepinephrineFormProvider =
    StateNotifierProvider<NorepinephrineFormNotifier, NorepinephrineFormState>(
        (ref) {
  return NorepinephrineFormNotifier();
});

/// Calculation result provider
final norepinephrineResultProvider =
    Provider.autoDispose<NorepinephrineResult?>((ref) {
  final formState = ref.watch(norepinephrineFormProvider);
  final repository = ref.watch(norepinephrineRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    final dose = double.parse(formState.dose!);
    return repository.calculate(
      weightKg: weight,
      doseUgPerKgPerMin: dose,
    );
  } catch (e) {
    return null;
  }
});
