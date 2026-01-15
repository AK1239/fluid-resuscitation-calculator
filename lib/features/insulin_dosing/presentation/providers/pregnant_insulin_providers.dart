import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/insulin_dosing/data/repositories/pregnant_insulin_repository_impl.dart';
import 'package:chemical_app/features/insulin_dosing/domain/entities/pregnant_insulin_result.dart';

/// Repository provider
final pregnantInsulinRepositoryProvider =
    Provider<PregnantInsulinRepositoryImpl>((ref) {
  return PregnantInsulinRepositoryImpl();
});

/// Form state
class PregnantInsulinFormState {
  final String? maternalWeight;
  final String? trimester; // "1st", "2nd", "3rd"
  final String? obesityClass; // "None", "Class II", "Class III"
  final String? currentRegimen; // "None", "Basal-bolus", "Four-injection regimen"
  final Set<String> glucosePatterns; // Selected glucose patterns

  const PregnantInsulinFormState({
    this.maternalWeight,
    this.trimester,
    this.obesityClass,
    this.currentRegimen,
    this.glucosePatterns = const {},
  });

  PregnantInsulinFormState copyWith({
    String? maternalWeight,
    String? trimester,
    String? obesityClass,
    String? currentRegimen,
    Set<String>? glucosePatterns,
  }) {
    return PregnantInsulinFormState(
      maternalWeight: maternalWeight ?? this.maternalWeight,
      trimester: trimester ?? this.trimester,
      obesityClass: obesityClass ?? this.obesityClass,
      currentRegimen: currentRegimen ?? this.currentRegimen,
      glucosePatterns: glucosePatterns ?? this.glucosePatterns,
    );
  }

  bool get isValid {
    if (maternalWeight == null || maternalWeight!.isEmpty) return false;
    final weight = double.tryParse(maternalWeight!);
    if (weight == null || weight <= 0) return false;
    
    return trimester != null &&
        obesityClass != null &&
        currentRegimen != null;
  }
}

/// Form state notifier
class PregnantInsulinFormNotifier extends StateNotifier<PregnantInsulinFormState> {
  PregnantInsulinFormNotifier() : super(const PregnantInsulinFormState());

  void setMaternalWeight(String? weight) {
    state = state.copyWith(maternalWeight: weight);
  }

  void setTrimester(String? trimester) {
    state = state.copyWith(trimester: trimester);
  }

  void setObesityClass(String? obesityClass) {
    state = state.copyWith(obesityClass: obesityClass);
  }

  void setCurrentRegimen(String? regimen) {
    state = state.copyWith(currentRegimen: regimen);
  }

  void toggleGlucosePattern(String pattern) {
    final newPatterns = Set<String>.from(state.glucosePatterns);
    if (newPatterns.contains(pattern)) {
      newPatterns.remove(pattern);
    } else {
      newPatterns.add(pattern);
    }
    state = state.copyWith(glucosePatterns: newPatterns);
  }

  void reset() {
    state = const PregnantInsulinFormState();
  }
}

final pregnantInsulinFormProvider =
    StateNotifierProvider<PregnantInsulinFormNotifier, PregnantInsulinFormState>(
        (ref) {
  return PregnantInsulinFormNotifier();
});

/// Calculation result provider
final pregnantInsulinResultProvider =
    Provider.autoDispose<PregnantInsulinResult?>((ref) {
  final formState = ref.watch(pregnantInsulinFormProvider);
  final repository = ref.watch(pregnantInsulinRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.maternalWeight!);
    return repository.calculate(
      maternalWeightKg: weight,
      trimester: formState.trimester!,
      obesityClass: formState.obesityClass!,
      currentRegimen: formState.currentRegimen!,
      glucosePatterns: formState.glucosePatterns,
    );
  } catch (e) {
    return null;
  }
});
