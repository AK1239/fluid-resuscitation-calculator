import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/shock_index/data/repositories/shock_index_repository_impl.dart';
import 'package:chemical_app/features/shock_index/domain/entities/shock_index_result.dart';

/// Repository provider
final shockIndexRepositoryProvider =
    Provider<ShockIndexRepositoryImpl>((ref) {
  return ShockIndexRepositoryImpl();
});

/// Form state
class ShockIndexFormState {
  final String? heartRate;
  final String? systolicBp;
  final String? age;

  const ShockIndexFormState({
    this.heartRate,
    this.systolicBp,
    this.age,
  });

  ShockIndexFormState copyWith({
    String? heartRate,
    String? systolicBp,
    String? age,
  }) {
    return ShockIndexFormState(
      heartRate: heartRate ?? this.heartRate,
      systolicBp: systolicBp ?? this.systolicBp,
      age: age ?? this.age,
    );
  }

  bool get isValid {
    if (heartRate == null ||
        heartRate!.isEmpty ||
        systolicBp == null ||
        systolicBp!.isEmpty) {
      return false;
    }

    final hr = double.tryParse(heartRate!);
    final sbp = double.tryParse(systolicBp!);

    if (hr == null || sbp == null) {
      return false;
    }

    // Validate ranges
    if (hr <= 0 || sbp <= 0) {
      return false;
    }

    // Age is optional, but if provided, validate it
    if (age != null && age!.isNotEmpty) {
      final ageValue = double.tryParse(age!);
      if (ageValue == null || ageValue < 0) {
        return false;
      }
    }

    return true;
  }
}

/// Form state notifier
class ShockIndexFormNotifier extends StateNotifier<ShockIndexFormState> {
  ShockIndexFormNotifier() : super(const ShockIndexFormState());

  void setHeartRate(String? heartRate) {
    state = state.copyWith(heartRate: heartRate);
  }

  void setSystolicBp(String? systolicBp) {
    state = state.copyWith(systolicBp: systolicBp);
  }

  void setAge(String? age) {
    state = state.copyWith(age: age);
  }

  void reset() {
    state = const ShockIndexFormState();
  }
}

final shockIndexFormProvider =
    StateNotifierProvider<ShockIndexFormNotifier, ShockIndexFormState>(
        (ref) {
  return ShockIndexFormNotifier();
});

/// Calculation result provider
final shockIndexResultProvider =
    Provider.autoDispose<ShockIndexResult?>((ref) {
  final formState = ref.watch(shockIndexFormProvider);
  final repository = ref.watch(shockIndexRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final heartRate = double.parse(formState.heartRate!);
    final systolicBp = double.parse(formState.systolicBp!);
    final age = formState.age != null && formState.age!.isNotEmpty
        ? double.parse(formState.age!)
        : null;

    return repository.calculate(
      heartRate: heartRate,
      systolicBp: systolicBp,
      age: age,
    );
  } catch (e) {
    return null;
  }
});
