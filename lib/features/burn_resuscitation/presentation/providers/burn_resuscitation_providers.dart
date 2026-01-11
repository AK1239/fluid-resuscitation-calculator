import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/burn_resuscitation/data/repositories/burn_resuscitation_repository_impl.dart';
import 'package:chemical_app/features/burn_resuscitation/domain/entities/burn_resuscitation_result.dart';

/// Repository provider
final burnResuscitationRepositoryProvider =
    Provider<BurnResuscitationRepositoryImpl>((ref) {
  return BurnResuscitationRepositoryImpl();
});

/// Form state
class BurnResuscitationFormState {
  final String? ageYears;
  final String? weightKg;
  final String? tbsaPercent;
  final String? timeSinceBurnHours;
  final bool? hasInhalationInjury;
  final bool? hasUrineOutputAvailable;

  const BurnResuscitationFormState({
    this.ageYears,
    this.weightKg,
    this.tbsaPercent,
    this.timeSinceBurnHours,
    this.hasInhalationInjury,
    this.hasUrineOutputAvailable,
  });

  BurnResuscitationFormState copyWith({
    String? ageYears,
    String? weightKg,
    String? tbsaPercent,
    String? timeSinceBurnHours,
    bool? hasInhalationInjury,
    bool? hasUrineOutputAvailable,
  }) {
    return BurnResuscitationFormState(
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      tbsaPercent: tbsaPercent ?? this.tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours ?? this.timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury ?? this.hasInhalationInjury,
      hasUrineOutputAvailable:
          hasUrineOutputAvailable ?? this.hasUrineOutputAvailable,
    );
  }

  bool get isValid {
    return ageYears != null &&
        ageYears!.isNotEmpty &&
        int.tryParse(ageYears!) != null &&
        int.parse(ageYears!) >= 0 &&
        weightKg != null &&
        weightKg!.isNotEmpty &&
        double.tryParse(weightKg!) != null &&
        double.parse(weightKg!) > 0 &&
        tbsaPercent != null &&
        tbsaPercent!.isNotEmpty &&
        double.tryParse(tbsaPercent!) != null &&
        double.parse(tbsaPercent!) > 0 &&
        double.parse(tbsaPercent!) <= 100 &&
        timeSinceBurnHours != null &&
        timeSinceBurnHours!.isNotEmpty &&
        int.tryParse(timeSinceBurnHours!) != null &&
        int.parse(timeSinceBurnHours!) >= 0 &&
        hasInhalationInjury != null &&
        hasUrineOutputAvailable != null;
  }
}

/// Form state notifier
class BurnResuscitationFormNotifier
    extends StateNotifier<BurnResuscitationFormState> {
  BurnResuscitationFormNotifier() : super(const BurnResuscitationFormState());

  void setAgeYears(String? ageYears) {
    state = state.copyWith(ageYears: ageYears);
  }

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setTbsaPercent(String? tbsaPercent) {
    state = state.copyWith(tbsaPercent: tbsaPercent);
  }

  void setTimeSinceBurnHours(String? timeSinceBurnHours) {
    state = state.copyWith(timeSinceBurnHours: timeSinceBurnHours);
  }

  void setHasInhalationInjury(bool? hasInhalationInjury) {
    state = state.copyWith(hasInhalationInjury: hasInhalationInjury);
  }

  void setHasUrineOutputAvailable(bool? hasUrineOutputAvailable) {
    state = state.copyWith(hasUrineOutputAvailable: hasUrineOutputAvailable);
  }

  void reset() {
    state = const BurnResuscitationFormState();
  }
}

final burnResuscitationFormProvider = StateNotifierProvider<
    BurnResuscitationFormNotifier, BurnResuscitationFormState>((ref) {
  return BurnResuscitationFormNotifier();
});

/// Calculation result provider
final burnResuscitationResultProvider =
    Provider.autoDispose<BurnResuscitationResult?>((ref) {
  final formState = ref.watch(burnResuscitationFormProvider);
  final repository = ref.watch(burnResuscitationRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final ageYears = int.parse(formState.ageYears!);
    final weightKg = double.parse(formState.weightKg!);
    final tbsaPercent = double.parse(formState.tbsaPercent!);
    final timeSinceBurnHours = int.parse(formState.timeSinceBurnHours!);
    final hasInhalationInjury = formState.hasInhalationInjury!;
    final hasUrineOutputAvailable = formState.hasUrineOutputAvailable!;

    return repository.calculate(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasUrineOutputAvailable: hasUrineOutputAvailable,
    );
  } catch (e) {
    return null;
  }
});
