import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/data/repositories/pediatric_burn_resuscitation_repository_impl.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/domain/entities/pediatric_burn_resuscitation_result.dart';

/// Repository provider
final pediatricBurnResuscitationRepositoryProvider =
    Provider<PediatricBurnResuscitationRepositoryImpl>((ref) {
  return PediatricBurnResuscitationRepositoryImpl();
});

/// Form state
class PediatricBurnResuscitationFormState {
  final String? ageYears;
  final String? weightKg;
  final String? tbsaPercent;
  final String? timeSinceBurnHours;
  final bool? hasInhalationInjury;
  final bool? hasElectricalInjury;

  const PediatricBurnResuscitationFormState({
    this.ageYears,
    this.weightKg,
    this.tbsaPercent,
    this.timeSinceBurnHours,
    this.hasInhalationInjury,
    this.hasElectricalInjury,
  });

  PediatricBurnResuscitationFormState copyWith({
    String? ageYears,
    String? weightKg,
    String? tbsaPercent,
    String? timeSinceBurnHours,
    bool? hasInhalationInjury,
    bool? hasElectricalInjury,
  }) {
    return PediatricBurnResuscitationFormState(
      ageYears: ageYears ?? this.ageYears,
      weightKg: weightKg ?? this.weightKg,
      tbsaPercent: tbsaPercent ?? this.tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours ?? this.timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury ?? this.hasInhalationInjury,
      hasElectricalInjury: hasElectricalInjury ?? this.hasElectricalInjury,
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
        hasElectricalInjury != null;
  }
}

/// Form state notifier
class PediatricBurnResuscitationFormNotifier
    extends StateNotifier<PediatricBurnResuscitationFormState> {
  PediatricBurnResuscitationFormNotifier()
      : super(const PediatricBurnResuscitationFormState());

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

  void setHasElectricalInjury(bool? hasElectricalInjury) {
    state = state.copyWith(hasElectricalInjury: hasElectricalInjury);
  }

  void reset() {
    state = const PediatricBurnResuscitationFormState();
  }
}

final pediatricBurnResuscitationFormProvider = StateNotifierProvider<
    PediatricBurnResuscitationFormNotifier,
    PediatricBurnResuscitationFormState>((ref) {
  return PediatricBurnResuscitationFormNotifier();
});

/// Calculation result provider
final pediatricBurnResuscitationResultProvider =
    Provider.autoDispose<PediatricBurnResuscitationResult?>((ref) {
  final formState = ref.watch(pediatricBurnResuscitationFormProvider);
  final repository = ref.watch(pediatricBurnResuscitationRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final ageYears = int.parse(formState.ageYears!);
    final weightKg = double.parse(formState.weightKg!);
    final tbsaPercent = double.parse(formState.tbsaPercent!);
    final timeSinceBurnHours = int.parse(formState.timeSinceBurnHours!);
    final hasInhalationInjury = formState.hasInhalationInjury!;
    final hasElectricalInjury = formState.hasElectricalInjury!;

    return repository.calculate(
      ageYears: ageYears,
      weightKg: weightKg,
      tbsaPercent: tbsaPercent,
      timeSinceBurnHours: timeSinceBurnHours,
      hasInhalationInjury: hasInhalationInjury,
      hasElectricalInjury: hasElectricalInjury,
    );
  } catch (e) {
    return null;
  }
});
