import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/electrolytes/magnesium/data/repositories/magnesium_repository_impl.dart';
import 'package:chemical_app/features/electrolytes/magnesium/domain/entities/magnesium_correction_result.dart';

/// Repository provider
final magnesiumRepositoryProvider = Provider<MagnesiumRepositoryImpl>((ref) {
  return MagnesiumRepositoryImpl();
});

/// Form state
class MagnesiumFormState {
  final String? currentMg;
  final bool? isSymptomatic;

  const MagnesiumFormState({
    this.currentMg,
    this.isSymptomatic,
  });

  MagnesiumFormState copyWith({
    String? currentMg,
    bool? isSymptomatic,
  }) {
    return MagnesiumFormState(
      currentMg: currentMg ?? this.currentMg,
      isSymptomatic: isSymptomatic ?? this.isSymptomatic,
    );
  }

  bool get isValid {
    return currentMg != null &&
        currentMg!.isNotEmpty &&
        double.tryParse(currentMg!) != null &&
        isSymptomatic != null;
  }
}

/// Form state notifier
class MagnesiumFormNotifier extends StateNotifier<MagnesiumFormState> {
  MagnesiumFormNotifier() : super(const MagnesiumFormState());

  void setCurrentMg(String? currentMg) {
    state = state.copyWith(currentMg: currentMg);
  }

  void setIsSymptomatic(bool? isSymptomatic) {
    state = state.copyWith(isSymptomatic: isSymptomatic);
  }

  void reset() {
    state = const MagnesiumFormState();
  }
}

final magnesiumFormProvider =
    StateNotifierProvider<MagnesiumFormNotifier, MagnesiumFormState>((ref) {
  return MagnesiumFormNotifier();
});

/// Calculation result provider
final magnesiumResultProvider =
    Provider.autoDispose<MagnesiumCorrectionResult?>((ref) {
  final formState = ref.watch(magnesiumFormProvider);
  final repository = ref.watch(magnesiumRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final currentMg = double.parse(formState.currentMg!);
    return repository.calculate(
      currentMg: currentMg,
      isSymptomatic: formState.isSymptomatic!,
    );
  } catch (e) {
    return null;
  }
});

