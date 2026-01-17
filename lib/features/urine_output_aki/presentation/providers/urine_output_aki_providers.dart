import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/urine_output_aki/data/repositories/urine_output_aki_repository_impl.dart';
import 'package:chemical_app/features/urine_output_aki/domain/entities/urine_output_aki_result.dart';

/// Repository provider
final urineOutputAkiRepositoryProvider = Provider<UrineOutputAkiRepositoryImpl>(
  (ref) {
    return UrineOutputAkiRepositoryImpl();
  },
);

/// Form state
class UrineOutputAkiFormState {
  final String? currentVolume;
  final String? previousVolume;
  final DateTime? previousTime;
  final DateTime? currentTime;
  final String? weightKg;

  const UrineOutputAkiFormState({
    this.currentVolume,
    this.previousVolume,
    this.previousTime,
    this.currentTime,
    this.weightKg,
  });

  UrineOutputAkiFormState copyWith({
    String? currentVolume,
    String? previousVolume,
    DateTime? previousTime,
    DateTime? currentTime,
    String? weightKg,
  }) {
    return UrineOutputAkiFormState(
      currentVolume: currentVolume ?? this.currentVolume,
      previousVolume: previousVolume ?? this.previousVolume,
      previousTime: previousTime ?? this.previousTime,
      currentTime: currentTime ?? this.currentTime,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  bool get isValid {
    if (currentVolume == null ||
        currentVolume!.isEmpty ||
        weightKg == null ||
        weightKg!.isEmpty ||
        previousTime == null ||
        currentTime == null) {
      return false;
    }

    final currentVol = double.tryParse(currentVolume!);
    final previousVol = double.tryParse(previousVolume ?? '0');
    final weight = double.tryParse(weightKg!);

    if (currentVol == null || weight == null) {
      return false;
    }

    // Validate ranges
    if (currentVol < 0 || weight <= 0) {
      return false;
    }

    // Validate current volume >= previous volume
    if (previousVol != null && currentVol < previousVol) {
      return false;
    }

    // Validate time interval
    if (currentTime!.isBefore(previousTime!) ||
        currentTime!.isAtSameMomentAs(previousTime!)) {
      return false;
    }

    return true;
  }
}

/// Form state notifier
class UrineOutputAkiFormNotifier
    extends StateNotifier<UrineOutputAkiFormState> {
  UrineOutputAkiFormNotifier()
    : super(
        UrineOutputAkiFormState(
          previousVolume: '0',
          currentTime: DateTime.now(),
        ),
      );

  void setCurrentVolume(String? currentVolume) {
    state = state.copyWith(currentVolume: currentVolume);
  }

  void setPreviousVolume(String? previousVolume) {
    state = state.copyWith(previousVolume: previousVolume ?? '0');
  }

  void setPreviousTime(DateTime? previousTime) {
    state = state.copyWith(previousTime: previousTime);
  }

  void setCurrentTime(DateTime? currentTime) {
    state = state.copyWith(currentTime: currentTime ?? DateTime.now());
  }

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void reset() {
    state = UrineOutputAkiFormState(
      previousVolume: '0',
      currentTime: DateTime.now(),
    );
  }
}

final urineOutputAkiFormProvider =
    StateNotifierProvider<UrineOutputAkiFormNotifier, UrineOutputAkiFormState>((
      ref,
    ) {
      return UrineOutputAkiFormNotifier();
    });

/// Calculation result provider
final urineOutputAkiResultProvider =
    Provider.autoDispose<UrineOutputAkiResult?>((ref) {
      final formState = ref.watch(urineOutputAkiFormProvider);
      final repository = ref.watch(urineOutputAkiRepositoryProvider);

      if (!formState.isValid) {
        return null;
      }

      try {
        final currentVolume = double.parse(formState.currentVolume!);
        final previousVolume = double.parse(formState.previousVolume ?? '0');
        final weightKg = double.parse(formState.weightKg!);
        final previousTime = formState.previousTime!;
        final currentTime = formState.currentTime!;

        return repository.calculate(
          currentVolume: currentVolume,
          previousVolume: previousVolume,
          currentTime: currentTime,
          previousTime: previousTime,
          weightKg: weightKg,
        );
      } catch (e) {
        return null;
      }
    });
