import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/egfr_calculator/data/repositories/egfr_repository_impl.dart';
import 'package:chemical_app/features/egfr_calculator/domain/entities/egfr_result.dart';

/// Repository provider
final egfrRepositoryProvider = Provider<EgfrRepositoryImpl>((ref) {
  return EgfrRepositoryImpl();
});

/// Form state
class EgfrFormState {
  final String? serumCreatinine;
  final String? cystatinC;
  final String? age;
  final bool? isMale;

  const EgfrFormState({
    this.serumCreatinine,
    this.cystatinC,
    this.age,
    this.isMale,
  });

  EgfrFormState copyWith({
    String? serumCreatinine,
    String? cystatinC,
    String? age,
    bool? isMale,
  }) {
    return EgfrFormState(
      serumCreatinine: serumCreatinine ?? this.serumCreatinine,
      cystatinC: cystatinC ?? this.cystatinC,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
    );
  }

  bool get isValid {
    if (serumCreatinine == null ||
        serumCreatinine!.isEmpty ||
        age == null ||
        age!.isEmpty ||
        isMale == null) {
      return false;
    }

    final creatinine = double.tryParse(serumCreatinine!);
    final ageValue = int.tryParse(age!);

    if (creatinine == null || ageValue == null) {
      return false;
    }

    // Validate ranges
    if (creatinine <= 0) {
      return false;
    }
    if (ageValue < 0 || ageValue > 120) {
      return false;
    }

    // Cystatin C is optional, but if provided, validate it
    if (cystatinC != null && cystatinC!.isNotEmpty) {
      final cysC = double.tryParse(cystatinC!);
      if (cysC == null || cysC <= 0) {
        return false;
      }
    }

    return true;
  }
}

/// Form state notifier
class EgfrFormNotifier extends StateNotifier<EgfrFormState> {
  EgfrFormNotifier() : super(const EgfrFormState());

  void setSerumCreatinine(String? serumCreatinine) {
    state = state.copyWith(serumCreatinine: serumCreatinine);
  }

  void setCystatinC(String? cystatinC) {
    state = state.copyWith(cystatinC: cystatinC);
  }

  void setAge(String? age) {
    state = state.copyWith(age: age);
  }

  void setIsMale(bool? isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void reset() {
    state = const EgfrFormState();
  }
}

final egfrFormProvider =
    StateNotifierProvider<EgfrFormNotifier, EgfrFormState>((ref) {
  return EgfrFormNotifier();
});

/// Calculation result provider
final egfrResultProvider = Provider.autoDispose<EgfrResult?>((ref) {
  final formState = ref.watch(egfrFormProvider);
  final repository = ref.watch(egfrRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final serumCreatinine = double.parse(formState.serumCreatinine!);
    final cystatinC = formState.cystatinC != null && formState.cystatinC!.isNotEmpty
        ? double.parse(formState.cystatinC!)
        : null;
    final age = int.parse(formState.age!);
    final isMale = formState.isMale!;

    return repository.calculate(
      serumCreatinineUmolPerL: serumCreatinine,
      cystatinC: cystatinC,
      age: age,
      isMale: isMale,
    );
  } catch (e) {
    return null;
  }
});
