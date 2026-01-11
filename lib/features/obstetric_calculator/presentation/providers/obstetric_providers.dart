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
  // Today's date is automatically used, not stored in form state

  const ObstetricFormState({this.lmp});

  ObstetricFormState copyWith({DateTime? lmp}) {
    return ObstetricFormState(lmp: lmp ?? this.lmp);
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
        final today = DateTime.now();

        // Validate that today is after LMP (or same day)
        if (today.isBefore(DateTime(lmp.year, lmp.month, lmp.day))) {
          return null;
        }

        return repository.calculate(lmp: lmp, today: today);
      } catch (e) {
        return null;
      }
    });
