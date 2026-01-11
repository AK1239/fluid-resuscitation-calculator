import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/core/constants/dehydration_ranges.dart';
import 'package:chemical_app/features/fluid_resuscitation/data/repositories/fluid_resuscitation_repository_impl.dart';
import 'package:chemical_app/features/fluid_resuscitation/domain/entities/fluid_resuscitation_result.dart';

/// Repository provider
final fluidResuscitationRepositoryProvider =
    Provider<FluidResuscitationRepositoryImpl>((ref) {
  return FluidResuscitationRepositoryImpl();
});

/// Form state
class FluidResuscitationFormState {
  final PatientType? patientType;
  final String? weight;
  final DehydrationSeverity? severity;

  const FluidResuscitationFormState({
    this.patientType,
    this.weight,
    this.severity,
  });

  FluidResuscitationFormState copyWith({
    PatientType? patientType,
    String? weight,
    DehydrationSeverity? severity,
  }) {
    return FluidResuscitationFormState(
      patientType: patientType ?? this.patientType,
      weight: weight ?? this.weight,
      severity: severity ?? this.severity,
    );
  }

  bool get isValid {
    return patientType != null &&
        weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null &&
        severity != null;
  }
}

/// Form state notifier
class FluidResuscitationFormNotifier
    extends StateNotifier<FluidResuscitationFormState> {
  FluidResuscitationFormNotifier() : super(const FluidResuscitationFormState());

  void setPatientType(PatientType? type) {
    state = state.copyWith(patientType: type);
  }

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void setSeverity(DehydrationSeverity? severity) {
    state = state.copyWith(severity: severity);
  }

  void reset() {
    state = const FluidResuscitationFormState();
  }
}

final fluidResuscitationFormProvider =
    StateNotifierProvider<FluidResuscitationFormNotifier,
        FluidResuscitationFormState>((ref) {
  return FluidResuscitationFormNotifier();
});

/// Calculation result provider
final fluidResuscitationResultProvider =
    Provider.autoDispose<FluidResuscitationResult?>((ref) {
  final formState = ref.watch(fluidResuscitationFormProvider);
  final repository = ref.watch(fluidResuscitationRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    return repository.calculate(
      patientType: formState.patientType!,
      weightKg: weight,
      severity: formState.severity!,
    );
  } catch (e) {
    return null;
  }
});

