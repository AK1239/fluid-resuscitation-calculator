import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/maintenance_fluids/data/repositories/maintenance_fluid_repository_impl.dart';
import 'package:chemical_app/features/maintenance_fluids/domain/entities/maintenance_fluid_result.dart';

/// Repository provider
final maintenanceFluidRepositoryProvider =
    Provider<MaintenanceFluidRepositoryImpl>((ref) {
  return MaintenanceFluidRepositoryImpl();
});

/// Form state
class MaintenanceFluidFormState {
  final String? weight;

  const MaintenanceFluidFormState({
    this.weight,
  });

  MaintenanceFluidFormState copyWith({
    String? weight,
  }) {
    return MaintenanceFluidFormState(
      weight: weight ?? this.weight,
    );
  }

  bool get isValid {
    return weight != null &&
        weight!.isNotEmpty &&
        double.tryParse(weight!) != null;
  }
}

/// Form state notifier
class MaintenanceFluidFormNotifier
    extends StateNotifier<MaintenanceFluidFormState> {
  MaintenanceFluidFormNotifier() : super(const MaintenanceFluidFormState());

  void setWeight(String? weight) {
    state = state.copyWith(weight: weight);
  }

  void reset() {
    state = const MaintenanceFluidFormState();
  }
}

final maintenanceFluidFormProvider =
    StateNotifierProvider<MaintenanceFluidFormNotifier,
        MaintenanceFluidFormState>((ref) {
  return MaintenanceFluidFormNotifier();
});

/// Calculation result provider
final maintenanceFluidResultProvider =
    Provider.autoDispose<MaintenanceFluidResult?>((ref) {
  final formState = ref.watch(maintenanceFluidFormProvider);
  final repository = ref.watch(maintenanceFluidRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final weight = double.parse(formState.weight!);
    return repository.calculate(weightKg: weight);
  } catch (e) {
    return null;
  }
});

