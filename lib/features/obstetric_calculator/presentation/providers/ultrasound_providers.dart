import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/obstetric_calculator/data/repositories/ultrasound_repository_impl.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/ultrasound_calculation_result.dart';

/// Repository provider
final ultrasoundRepositoryProvider = Provider<UltrasoundRepositoryImpl>((ref) {
  return UltrasoundRepositoryImpl();
});

/// Form state
class UltrasoundFormState {
  final DateTime? ultrasoundDate;
  final String? gaWeeks;
  final String? gaDays;
  final DateTime? calculationDate; // Defaults to today if null

  const UltrasoundFormState({
    this.ultrasoundDate,
    this.gaWeeks,
    this.gaDays,
    this.calculationDate,
  });

  UltrasoundFormState copyWith({
    DateTime? ultrasoundDate,
    String? gaWeeks,
    String? gaDays,
    DateTime? calculationDate,
  }) {
    return UltrasoundFormState(
      ultrasoundDate: ultrasoundDate ?? this.ultrasoundDate,
      gaWeeks: gaWeeks ?? this.gaWeeks,
      gaDays: gaDays ?? this.gaDays,
      calculationDate: calculationDate ?? this.calculationDate,
    );
  }

  bool get isValid {
    if (ultrasoundDate == null) return false;
    if (gaWeeks == null || gaWeeks!.isEmpty) return false;
    if (gaDays == null || gaDays!.isEmpty) return false;

    final weeks = int.tryParse(gaWeeks!);
    final days = int.tryParse(gaDays!);

    if (weeks == null || weeks < 0) return false;
    if (days == null || days < 0 || days >= 7) return false;

    // Validate ultrasound date is not in the future (relative to calculation date)
    final calcDate = calculationDate ?? DateTime.now();
    if (ultrasoundDate!.isAfter(calcDate)) return false;

    return true;
  }
}

/// Form state notifier
class UltrasoundFormNotifier extends StateNotifier<UltrasoundFormState> {
  UltrasoundFormNotifier() : super(const UltrasoundFormState());

  void setUltrasoundDate(DateTime? ultrasoundDate) {
    state = state.copyWith(ultrasoundDate: ultrasoundDate);
  }

  void setGaWeeks(String? gaWeeks) {
    state = state.copyWith(gaWeeks: gaWeeks);
  }

  void setGaDays(String? gaDays) {
    state = state.copyWith(gaDays: gaDays);
  }

  void setCalculationDate(DateTime? calculationDate) {
    state = state.copyWith(calculationDate: calculationDate);
  }

  void reset() {
    state = const UltrasoundFormState();
  }
}

final ultrasoundFormProvider =
    StateNotifierProvider<UltrasoundFormNotifier, UltrasoundFormState>((ref) {
      return UltrasoundFormNotifier();
    });

/// Calculation result provider
final ultrasoundResultProvider =
    Provider.autoDispose<UltrasoundCalculationResult?>((ref) {
      final formState = ref.watch(ultrasoundFormProvider);
      final repository = ref.watch(ultrasoundRepositoryProvider);

      if (!formState.isValid) {
        return null;
      }

      try {
        final ultrasoundDate = formState.ultrasoundDate!;
        final gaWeeks = int.parse(formState.gaWeeks!);
        final gaDays = int.parse(formState.gaDays!);
        final calculationDate = formState.calculationDate ?? DateTime.now();

        return repository.calculate(
          ultrasoundDate: ultrasoundDate,
          gaWeeks: gaWeeks,
          gaDays: gaDays,
          calculationDate: calculationDate,
        );
      } catch (e) {
        return null;
      }
    });
