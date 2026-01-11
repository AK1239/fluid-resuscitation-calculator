import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/obstetric_calculator/data/repositories/obstetric_repository_impl.dart';
import 'package:chemical_app/features/obstetric_calculator/domain/entities/obstetric_calculation_result.dart';

/// Repository provider
final obstetricRepositoryProvider =
    Provider<ObstetricRepositoryImpl>((ref) {
  return ObstetricRepositoryImpl();
});

/// Form state
class ObstetricFormState {
  final String? lmp; // DD/MM/YYYY format
  final String? today; // DD/MM/YYYY format

  const ObstetricFormState({
    this.lmp,
    this.today,
  });

  ObstetricFormState copyWith({
    String? lmp,
    String? today,
  }) {
    return ObstetricFormState(
      lmp: lmp ?? this.lmp,
      today: today ?? this.today,
    );
  }

  bool get isValid {
    return lmp != null &&
        lmp!.isNotEmpty &&
        _isValidDateFormat(lmp!) &&
        today != null &&
        today!.isNotEmpty &&
        _isValidDateFormat(today!);
  }

  /// Validates DD/MM/YYYY format
  bool _isValidDateFormat(String date) {
    final parts = date.split('/');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    if (year < 1900 || year > 2100) return false;

    // Basic validation - check if date is valid
    try {
      DateTime(year, month, day);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Parses date from DD/MM/YYYY format
  DateTime? parseDate(String dateStr) {
    if (!_isValidDateFormat(dateStr)) return null;
    final parts = dateStr.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    try {
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}

/// Form state notifier
class ObstetricFormNotifier extends StateNotifier<ObstetricFormState> {
  ObstetricFormNotifier() : super(const ObstetricFormState());

  void setLmp(String? lmp) {
    state = state.copyWith(lmp: lmp);
  }

  void setToday(String? today) {
    state = state.copyWith(today: today);
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
    final lmp = formState.parseDate(formState.lmp!);
    final today = formState.parseDate(formState.today!);

    if (lmp == null || today == null) {
      return null;
    }

    // Validate that today is after LMP
    if (today.isBefore(lmp)) {
      return null;
    }

    return repository.calculate(
      lmp: lmp,
      today: today,
    );
  } catch (e) {
    return null;
  }
});
