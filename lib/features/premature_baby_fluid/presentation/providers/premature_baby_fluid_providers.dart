import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/premature_baby_fluid/data/repositories/premature_baby_fluid_repository_impl.dart';
import 'package:chemical_app/features/premature_baby_fluid/domain/entities/premature_baby_fluid_result.dart';

/// Repository provider
final prematureBabyFluidRepositoryProvider =
    Provider<PrematureBabyFluidRepositoryImpl>((ref) {
  return PrematureBabyFluidRepositoryImpl();
});

/// Form state
class PrematureBabyFluidFormState {
  final GestationalCategory? gestationalCategory;
  final String? dayOfLife;
  final String? currentWeightKg;
  final bool? canTakeEbm;
  final Environment? environment;
  final bool hasSevereHie;
  final bool hasAki;
  final bool hasCerebralEdema;
  final bool hasMultiOrganDamage;

  const PrematureBabyFluidFormState({
    this.gestationalCategory,
    this.dayOfLife,
    this.currentWeightKg,
    this.canTakeEbm,
    this.environment,
    this.hasSevereHie = false,
    this.hasAki = false,
    this.hasCerebralEdema = false,
    this.hasMultiOrganDamage = false,
  });

  PrematureBabyFluidFormState copyWith({
    GestationalCategory? gestationalCategory,
    String? dayOfLife,
    String? currentWeightKg,
    bool? canTakeEbm,
    Environment? environment,
    bool? hasSevereHie,
    bool? hasAki,
    bool? hasCerebralEdema,
    bool? hasMultiOrganDamage,
  }) {
    return PrematureBabyFluidFormState(
      gestationalCategory: gestationalCategory ?? this.gestationalCategory,
      dayOfLife: dayOfLife ?? this.dayOfLife,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      canTakeEbm: canTakeEbm ?? this.canTakeEbm,
      environment: environment ?? this.environment,
      hasSevereHie: hasSevereHie ?? this.hasSevereHie,
      hasAki: hasAki ?? this.hasAki,
      hasCerebralEdema: hasCerebralEdema ?? this.hasCerebralEdema,
      hasMultiOrganDamage: hasMultiOrganDamage ?? this.hasMultiOrganDamage,
    );
  }

  bool get isValid {
    if (gestationalCategory == null ||
        dayOfLife == null ||
        dayOfLife!.isEmpty ||
        currentWeightKg == null ||
        currentWeightKg!.isEmpty ||
        canTakeEbm == null ||
        environment == null) {
      return false;
    }

    final day = int.tryParse(dayOfLife!);
    final currentWeight = double.tryParse(currentWeightKg!);

    if (day == null || currentWeight == null) {
      return false;
    }

    // Validate ranges
    if (day < 0 || day > 30) {
      return false;
    }
    if (currentWeight <= 0 || currentWeight > 5) {
      return false;
    }

    return true;
  }
}

/// Form state notifier
class PrematureBabyFluidFormNotifier
    extends StateNotifier<PrematureBabyFluidFormState> {
  PrematureBabyFluidFormNotifier()
      : super(const PrematureBabyFluidFormState());

  void setGestationalCategory(GestationalCategory? category) {
    state = state.copyWith(gestationalCategory: category);
  }

  void setDayOfLife(String? dayOfLife) {
    state = state.copyWith(dayOfLife: dayOfLife);
  }

  void setCurrentWeightKg(String? weight) {
    state = state.copyWith(currentWeightKg: weight);
  }

  void setCanTakeEbm(bool? canTakeEbm) {
    state = state.copyWith(canTakeEbm: canTakeEbm);
  }

  void setEnvironment(Environment? environment) {
    state = state.copyWith(environment: environment);
  }

  void setHasSevereHie(bool value) {
    state = state.copyWith(hasSevereHie: value);
  }

  void setHasAki(bool value) {
    state = state.copyWith(hasAki: value);
  }

  void setHasCerebralEdema(bool value) {
    state = state.copyWith(hasCerebralEdema: value);
  }

  void setHasMultiOrganDamage(bool value) {
    state = state.copyWith(hasMultiOrganDamage: value);
  }

  void reset() {
    state = const PrematureBabyFluidFormState();
  }
}

final prematureBabyFluidFormProvider =
    StateNotifierProvider<PrematureBabyFluidFormNotifier,
        PrematureBabyFluidFormState>((ref) {
  return PrematureBabyFluidFormNotifier();
});

/// Calculation result provider
final prematureBabyFluidResultProvider =
    Provider.autoDispose<PrematureBabyFluidResult?>((ref) {
  final formState = ref.watch(prematureBabyFluidFormProvider);
  final repository = ref.watch(prematureBabyFluidRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final dayOfLife = int.parse(formState.dayOfLife!);
    final currentWeightKg = double.parse(formState.currentWeightKg!);

    return repository.calculate(
      gestationalCategory: formState.gestationalCategory!,
      dayOfLife: dayOfLife,
      currentWeightKg: currentWeightKg,
      canTakeEbm: formState.canTakeEbm!,
      environment: formState.environment!,
      hasSevereHie: formState.hasSevereHie,
      hasAki: formState.hasAki,
      hasCerebralEdema: formState.hasCerebralEdema,
      hasMultiOrganDamage: formState.hasMultiOrganDamage,
    );
  } catch (e) {
    return null;
  }
});