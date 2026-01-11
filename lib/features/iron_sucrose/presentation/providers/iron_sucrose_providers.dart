import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/iron_sucrose/data/repositories/iron_sucrose_repository_impl.dart';
import 'package:chemical_app/features/iron_sucrose/domain/entities/iron_sucrose_result.dart';

/// Repository provider
final ironSucroseRepositoryProvider =
    Provider<IronSucroseRepositoryImpl>((ref) {
  return IronSucroseRepositoryImpl();
});

/// Form state
class IronSucroseFormState {
  final String? weightKg;
  final bool? isMale;
  final String? actualHb;
  final String? targetHb;
  final bool includeIronStores;

  const IronSucroseFormState({
    this.weightKg,
    this.isMale,
    this.actualHb,
    this.targetHb,
    this.includeIronStores = true,
  });

  IronSucroseFormState copyWith({
    String? weightKg,
    bool? isMale,
    String? actualHb,
    String? targetHb,
    bool? includeIronStores,
  }) {
    return IronSucroseFormState(
      weightKg: weightKg ?? this.weightKg,
      isMale: isMale ?? this.isMale,
      actualHb: actualHb ?? this.actualHb,
      targetHb: targetHb ?? this.targetHb,
      includeIronStores: includeIronStores ?? this.includeIronStores,
    );
  }

  bool get isValid {
    return weightKg != null &&
        weightKg!.isNotEmpty &&
        double.tryParse(weightKg!) != null &&
        double.parse(weightKg!) > 0 &&
        isMale != null &&
        actualHb != null &&
        actualHb!.isNotEmpty &&
        double.tryParse(actualHb!) != null &&
        double.parse(actualHb!) > 0 &&
        double.parse(actualHb!) <= 20; // Reasonable Hb range
  }

  double? get targetHbValue {
    if (targetHb != null && targetHb!.isNotEmpty) {
      final value = double.tryParse(targetHb!);
      if (value != null && value > 0 && value <= 20) {
        return value;
      }
    }
    return null; // Will use default based on sex
  }
}

/// Form state notifier
class IronSucroseFormNotifier extends StateNotifier<IronSucroseFormState> {
  IronSucroseFormNotifier() : super(const IronSucroseFormState());

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setIsMale(bool? isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void setActualHb(String? actualHb) {
    state = state.copyWith(actualHb: actualHb);
  }

  void setTargetHb(String? targetHb) {
    state = state.copyWith(targetHb: targetHb);
  }

  void setIncludeIronStores(bool includeIronStores) {
    state = state.copyWith(includeIronStores: includeIronStores);
  }

  void reset() {
    state = const IronSucroseFormState();
  }
}

final ironSucroseFormProvider =
    StateNotifierProvider<IronSucroseFormNotifier, IronSucroseFormState>(
        (ref) {
  return IronSucroseFormNotifier();
});

/// Calculation result provider
final ironSucroseResultProvider =
    Provider.autoDispose<IronSucroseResult?>((ref) {
  final formState = ref.watch(ironSucroseFormProvider);
  final repository = ref.watch(ironSucroseRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weightKg = double.parse(formState.weightKg!);
    final isMale = formState.isMale!;
    final actualHb = double.parse(formState.actualHb!);
    final targetHb = formState.targetHbValue;

    // Validate that actual Hb is less than target Hb
    final defaultTargetHb = isMale ? 13.0 : 12.0;
    final finalTargetHb = targetHb ?? defaultTargetHb;
    if (actualHb >= finalTargetHb) {
      return null; // Invalid: actual Hb should be less than target
    }

    return repository.calculate(
      weightKg: weightKg,
      isMale: isMale,
      actualHb: actualHb,
      targetHb: targetHb,
      includeIronStores: formState.includeIronStores,
    );
  } catch (e) {
    return null;
  }
});
