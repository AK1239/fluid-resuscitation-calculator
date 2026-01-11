import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/insulin_dosing/data/repositories/insulin_dosing_repository_impl.dart';
import 'package:chemical_app/features/insulin_dosing/domain/entities/insulin_dosing_result.dart';

/// Repository provider
final insulinDosingRepositoryProvider =
    Provider<InsulinDosingRepositoryImpl>((ref) {
  return InsulinDosingRepositoryImpl();
});

/// Form state
class InsulinDosingFormState {
  final String? weight;
  final String? tddFactor;

  const InsulinDosingFormState({
    this.weight,
    this.tddFactor,
  });

  InsulinDosingFormState copyWith({
    String? weight,
    String? tddFactor,
  }) {
    return InsulinDosingFormState(
      weight: weight ?? this.weight,
      tddFactor: tddFactor ?? this.tddFactor,
    );
  }

  bool get isValid {
    return weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        double.parse(weight!) > 0;
  }

  double get tddFactorValue {
    if (tddFactor != null && tddFactor!.isNotEmpty) {
      final factor = double.tryParse(tddFactor!);
      if (factor != null && factor > 0) {
        return factor;
      }
    }
    return 0.5; // Default value
  }
}

/// Form state notifier
class InsulinDosingFormNotifier extends StateNotifier<InsulinDosingFormState> {
  InsulinDosingFormNotifier() : super(const InsulinDosingFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setTddFactor(String? tddFactor) {
    state = state.copyWith(tddFactor: tddFactor);
  }

  void reset() {
    state = const InsulinDosingFormState();
  }
}

final insulinDosingFormProvider =
    StateNotifierProvider<InsulinDosingFormNotifier, InsulinDosingFormState>(
        (ref) {
  return InsulinDosingFormNotifier();
});

/// Calculation result provider
final insulinDosingResultProvider =
    Provider.autoDispose<InsulinDosingResult?>((ref) {
  final formState = ref.watch(insulinDosingFormProvider);
  final repository = ref.watch(insulinDosingRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    final tddFactor = formState.tddFactorValue;
    return repository.calculate(
      weightKg: weight,
      tddFactor: tddFactor,
    );
  } catch (e) {
    return null;
  }
});
