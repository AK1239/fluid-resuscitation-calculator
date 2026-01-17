import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/map_pulse_pressure/data/repositories/map_pulse_pressure_repository_impl.dart';
import 'package:chemical_app/features/map_pulse_pressure/domain/entities/map_pulse_pressure_result.dart';

/// Repository provider
final mapPulsePressureRepositoryProvider =
    Provider<MapPulsePressureRepositoryImpl>((ref) {
  return MapPulsePressureRepositoryImpl();
});

/// Form state
class MapPulsePressureFormState {
  final String? systolicBp;
  final String? diastolicBp;

  const MapPulsePressureFormState({
    this.systolicBp,
    this.diastolicBp,
  });

  MapPulsePressureFormState copyWith({
    String? systolicBp,
    String? diastolicBp,
  }) {
    return MapPulsePressureFormState(
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
    );
  }

  bool get isValid {
    if (systolicBp == null ||
        systolicBp!.isEmpty ||
        diastolicBp == null ||
        diastolicBp!.isEmpty) {
      return false;
    }

    final sbp = double.tryParse(systolicBp!);
    final dbp = double.tryParse(diastolicBp!);

    if (sbp == null || dbp == null) {
      return false;
    }

    // Validate ranges
    if (sbp < 40 || sbp > 300 || dbp < 40 || dbp > 300) {
      return false;
    }

    // Validate SBP > DBP
    if (sbp <= dbp) {
      return false;
    }

    return true;
  }
}

/// Form state notifier
class MapPulsePressureFormNotifier
    extends StateNotifier<MapPulsePressureFormState> {
  MapPulsePressureFormNotifier() : super(const MapPulsePressureFormState());

  void setSystolicBp(String? systolicBp) {
    state = state.copyWith(systolicBp: systolicBp);
  }

  void setDiastolicBp(String? diastolicBp) {
    state = state.copyWith(diastolicBp: diastolicBp);
  }

  void reset() {
    state = const MapPulsePressureFormState();
  }
}

final mapPulsePressureFormProvider =
    StateNotifierProvider<MapPulsePressureFormNotifier,
        MapPulsePressureFormState>((ref) {
  return MapPulsePressureFormNotifier();
});

/// Calculation result provider
final mapPulsePressureResultProvider =
    Provider.autoDispose<MapPulsePressureResult?>((ref) {
  final formState = ref.watch(mapPulsePressureFormProvider);
  final repository = ref.watch(mapPulsePressureRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final systolicBp = double.parse(formState.systolicBp!);
    final diastolicBp = double.parse(formState.diastolicBp!);
    return repository.calculate(
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
    );
  } catch (e) {
    return null;
  }
});
