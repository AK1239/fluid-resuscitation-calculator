import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/who_growth_assessment/data/repositories/who_growth_repository_impl.dart';
import 'package:chemical_app/features/who_growth_assessment/domain/entities/who_growth_assessment_result.dart';

/// Repository provider
final whoGrowthRepositoryProvider =
    Provider<WhoGrowthRepositoryImpl>((ref) {
  return WhoGrowthRepositoryImpl();
});

/// Form state
class WhoGrowthFormState {
  final String? ageMonths;
  final bool? isMale;
  final String? weightKg;
  final String? heightCm;
  final String? waz;
  final String? haz;
  final String? whz;

  const WhoGrowthFormState({
    this.ageMonths,
    this.isMale,
    this.weightKg,
    this.heightCm,
    this.waz,
    this.haz,
    this.whz,
  });

  WhoGrowthFormState copyWith({
    String? ageMonths,
    bool? isMale,
    String? weightKg,
    String? heightCm,
    String? waz,
    String? haz,
    String? whz,
  }) {
    return WhoGrowthFormState(
      ageMonths: ageMonths ?? this.ageMonths,
      isMale: isMale ?? this.isMale,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      waz: waz ?? this.waz,
      haz: haz ?? this.haz,
      whz: whz ?? this.whz,
    );
  }

  bool get isValid {
    return ageMonths != null &&
        ageMonths!.isNotEmpty &&
        int.tryParse(ageMonths!) != null &&
        int.parse(ageMonths!) >= 0 &&
        int.parse(ageMonths!) <= 59 &&
        isMale != null &&
        weightKg != null &&
        weightKg!.isNotEmpty &&
        double.tryParse(weightKg!) != null &&
        double.parse(weightKg!) > 0 &&
        heightCm != null &&
        heightCm!.isNotEmpty &&
        double.tryParse(heightCm!) != null &&
        double.parse(heightCm!) > 0 &&
        waz != null &&
        waz!.isNotEmpty &&
        double.tryParse(waz!) != null &&
        haz != null &&
        haz!.isNotEmpty &&
        double.tryParse(haz!) != null &&
        whz != null &&
        whz!.isNotEmpty &&
        double.tryParse(whz!) != null;
  }
}

/// Form state notifier
class WhoGrowthFormNotifier extends StateNotifier<WhoGrowthFormState> {
  WhoGrowthFormNotifier() : super(const WhoGrowthFormState());

  void setAgeMonths(String? ageMonths) {
    state = state.copyWith(ageMonths: ageMonths);
  }

  void setIsMale(bool? isMale) {
    state = state.copyWith(isMale: isMale);
  }

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setHeightCm(String? heightCm) {
    state = state.copyWith(heightCm: heightCm);
  }

  void setWaz(String? waz) {
    state = state.copyWith(waz: waz);
  }

  void setHaz(String? haz) {
    state = state.copyWith(haz: haz);
  }

  void setWhz(String? whz) {
    state = state.copyWith(whz: whz);
  }

  void reset() {
    state = const WhoGrowthFormState();
  }
}

final whoGrowthFormProvider =
    StateNotifierProvider<WhoGrowthFormNotifier, WhoGrowthFormState>((ref) {
  return WhoGrowthFormNotifier();
});

/// Calculation result provider
final whoGrowthResultProvider =
    Provider.autoDispose<WhoGrowthAssessmentResult?>((ref) {
  final formState = ref.watch(whoGrowthFormProvider);
  final repository = ref.watch(whoGrowthRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final ageMonths = int.parse(formState.ageMonths!);
    final isMale = formState.isMale!;
    final weightKg = double.parse(formState.weightKg!);
    final heightCm = double.parse(formState.heightCm!);
    final waz = double.parse(formState.waz!);
    final haz = double.parse(formState.haz!);
    final whz = double.parse(formState.whz!);

    return repository.assess(
      ageMonths: ageMonths,
      isMale: isMale,
      weightKg: weightKg,
      heightCm: heightCm,
      waz: waz,
      haz: haz,
      whz: whz,
    );
  } catch (e) {
    return null;
  }
});
