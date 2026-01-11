import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/developmental_screening/data/repositories/developmental_repository_impl.dart';
import 'package:chemical_app/features/developmental_screening/domain/entities/developmental_assessment_result.dart';

/// Repository provider
final developmentalRepositoryProvider =
    Provider<DevelopmentalRepositoryImpl>((ref) {
  return DevelopmentalRepositoryImpl();
});

/// Form state
class DevelopmentalFormState {
  final String? ageMonths;
  final bool isCorrectedAge;
  final String? correctedAgeMonths;
  final Map<DevelopmentalDomain, DomainClassification?> domainClassifications;

  const DevelopmentalFormState({
    this.ageMonths,
    this.isCorrectedAge = false,
    this.correctedAgeMonths,
    Map<DevelopmentalDomain, DomainClassification?>? domainClassifications,
  }) : domainClassifications = domainClassifications ?? const {};

  DevelopmentalFormState copyWith({
    String? ageMonths,
    bool? isCorrectedAge,
    String? correctedAgeMonths,
    Map<DevelopmentalDomain, DomainClassification?>? domainClassifications,
  }) {
    return DevelopmentalFormState(
      ageMonths: ageMonths ?? this.ageMonths,
      isCorrectedAge: isCorrectedAge ?? this.isCorrectedAge,
      correctedAgeMonths: correctedAgeMonths ?? this.correctedAgeMonths,
      domainClassifications: domainClassifications ?? this.domainClassifications,
    );
  }

  bool get isValid {
    if (ageMonths == null ||
        ageMonths!.isEmpty ||
        int.tryParse(ageMonths!) == null ||
        int.parse(ageMonths!) < 0) {
      return false;
    }

    if (isCorrectedAge) {
      if (correctedAgeMonths == null ||
          correctedAgeMonths!.isEmpty ||
          int.tryParse(correctedAgeMonths!) == null ||
          int.parse(correctedAgeMonths!) < 0) {
        return false;
      }
    }

    // At least one domain should be classified
    return domainClassifications.values.any((classification) => classification != null);
  }
}

/// Form state notifier
class DevelopmentalFormNotifier extends StateNotifier<DevelopmentalFormState> {
  DevelopmentalFormNotifier() : super(const DevelopmentalFormState());

  void setAgeMonths(String? ageMonths) {
    state = state.copyWith(ageMonths: ageMonths);
  }

  void setIsCorrectedAge(bool isCorrectedAge) {
    state = state.copyWith(isCorrectedAge: isCorrectedAge);
  }

  void setCorrectedAgeMonths(String? correctedAgeMonths) {
    state = state.copyWith(correctedAgeMonths: correctedAgeMonths);
  }

  void setDomainClassification(
    DevelopmentalDomain domain,
    DomainClassification? classification,
  ) {
    final updated = Map<DevelopmentalDomain, DomainClassification?>.from(
      state.domainClassifications,
    );
    updated[domain] = classification;
    state = state.copyWith(domainClassifications: updated);
  }

  void reset() {
    state = const DevelopmentalFormState();
  }
}

final developmentalFormProvider = StateNotifierProvider<
    DevelopmentalFormNotifier, DevelopmentalFormState>((ref) {
  return DevelopmentalFormNotifier();
});

/// Calculation result provider
final developmentalResultProvider =
    Provider.autoDispose<DevelopmentalAssessmentResult?>((ref) {
  final formState = ref.watch(developmentalFormProvider);
  final repository = ref.watch(developmentalRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final ageMonths = int.parse(formState.ageMonths!);
    final correctedAgeMonths = formState.isCorrectedAge &&
            formState.correctedAgeMonths != null
        ? int.parse(formState.correctedAgeMonths!)
        : null;

    // Filter out null classifications
    final classifications = <DevelopmentalDomain, DomainClassification>{};
    for (final entry in formState.domainClassifications.entries) {
      if (entry.value != null) {
        classifications[entry.key] = entry.value!;
      }
    }

    return repository.assess(
      ageMonths: ageMonths,
      isCorrectedAge: formState.isCorrectedAge,
      correctedAgeMonths: correctedAgeMonths,
      domainClassifications: classifications,
    );
  } catch (e) {
    return null;
  }
});
