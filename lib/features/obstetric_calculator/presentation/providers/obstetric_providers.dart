import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/obstetric_calculator/data/repositories/obstetric_repository_impl.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/obstetric_calculation_result.dart';

/// Repository provider
final obstetricRepositoryProvider = Provider<ObstetricRepositoryImpl>((ref) {
  return ObstetricRepositoryImpl();
});

/// Form state
class ObstetricFormState {
  final DateTime? lmp; // LMP date
  final DateTime? calculationDate; // Date for GA calculation (defaults to today if null)

  const ObstetricFormState({
    this.lmp,
    this.calculationDate,
  });

  ObstetricFormState copyWith({
    DateTime? lmp,
    DateTime? calculationDate,
  }) {
    return ObstetricFormState(
      lmp: lmp ?? this.lmp,
      calculationDate: calculationDate ?? this.calculationDate,
    );
  }

  bool get isValid {
    return lmp != null;
  }
}

/// Form state notifier
class ObstetricFormNotifier extends StateNotifier<ObstetricFormState> {
  ObstetricFormNotifier() : super(const ObstetricFormState());

  void setLmp(DateTime? lmp) {
    state = state.copyWith(lmp: lmp);
  }

  void setCalculationDate(DateTime? calculationDate) {
    state = state.copyWith(calculationDate: calculationDate);
  }

  void reset() {
    state = const ObstetricFormState();
  }
}

final obstetricFormProvider =
    StateNotifierProvider<ObstetricFormNotifier, ObstetricFormState>((ref) {
      return ObstetricFormNotifier();
    });

/// Calculation result provider
final obstetricResultProvider =
    Provider.autoDispose<ObstetricCalculationResult?>((ref) {
      final formState = ref.watch(obstetricFormProvider);
      final repository = ref.watch(obstetricRepositoryProvider);

      if (!formState.isValid) {
        return null;
      }

      try {
        final lmp = formState.lmp!;
        final calculationDate = formState.calculationDate ?? DateTime.now();

        // Validate that calculation date is after LMP (or same day)
        if (calculationDate.isBefore(DateTime(lmp.year, lmp.month, lmp.day))) {
          return null;
        }

        return repository.calculate(lmp: lmp, today: calculationDate);
      } catch (e) {
        return null;
      }
    });
