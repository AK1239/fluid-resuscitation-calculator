import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/atls_shock_classification/data/repositories/atls_shock_repository_impl.dart';
import 'package:chemical_app/features/atls_shock_classification/domain/entities/atls_shock_result.dart';

/// Repository provider
final atlsShockRepositoryProvider =
    Provider<AtlsShockRepositoryImpl>((ref) {
  return AtlsShockRepositoryImpl();
});

/// Form state
class AtlsShockFormState {
  final String? age;
  final String? weightKg;
  final String? systolicBp;
  final String? diastolicBp;
  final String? heartRate;
  final String? respiratoryRate;
  final String? totalUrineVolume;
  final String? timeSinceCatheterHours;
  final MentalStatus? mentalStatus;
  final String? baseDeficit;
  final String? estimatedBloodLossPercent;
  final String? estimatedBloodLossMl;

  const AtlsShockFormState({
    this.age,
    this.weightKg,
    this.systolicBp,
    this.diastolicBp,
    this.heartRate,
    this.respiratoryRate,
    this.totalUrineVolume,
    this.timeSinceCatheterHours,
    this.mentalStatus,
    this.baseDeficit,
    this.estimatedBloodLossPercent,
    this.estimatedBloodLossMl,
  });

  AtlsShockFormState copyWith({
    String? age,
    String? weightKg,
    String? systolicBp,
    String? diastolicBp,
    String? heartRate,
    String? respiratoryRate,
    String? totalUrineVolume,
    String? timeSinceCatheterHours,
    MentalStatus? mentalStatus,
    String? baseDeficit,
    String? estimatedBloodLossPercent,
    String? estimatedBloodLossMl,
  }) {
    return AtlsShockFormState(
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      heartRate: heartRate ?? this.heartRate,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      totalUrineVolume: totalUrineVolume ?? this.totalUrineVolume,
      timeSinceCatheterHours:
          timeSinceCatheterHours ?? this.timeSinceCatheterHours,
      mentalStatus: mentalStatus ?? this.mentalStatus,
      baseDeficit: baseDeficit ?? this.baseDeficit,
      estimatedBloodLossPercent:
          estimatedBloodLossPercent ?? this.estimatedBloodLossPercent,
      estimatedBloodLossMl: estimatedBloodLossMl ?? this.estimatedBloodLossMl,
    );
  }

  bool get isValid {
    // Required fields
    if (systolicBp == null ||
        systolicBp!.isEmpty ||
        diastolicBp == null ||
        diastolicBp!.isEmpty ||
        respiratoryRate == null ||
        respiratoryRate!.isEmpty ||
        mentalStatus == null) {
      return false;
    }

    final sbp = double.tryParse(systolicBp!);
    final dbp = double.tryParse(diastolicBp!);
    final rr = int.tryParse(respiratoryRate!);

    if (sbp == null || dbp == null || rr == null) {
      return false;
    }

    // Validate SBP > DBP
    if (sbp <= dbp) {
      return false;
    }

    // Validate ranges
    if (sbp <= 0 || dbp <= 0 || rr <= 0) {
      return false;
    }

    return true;
  }
}

/// Form state notifier
class AtlsShockFormNotifier extends StateNotifier<AtlsShockFormState> {
  AtlsShockFormNotifier() : super(const AtlsShockFormState());

  void setAge(String? age) {
    state = state.copyWith(age: age);
  }

  void setWeightKg(String? weightKg) {
    state = state.copyWith(weightKg: weightKg);
  }

  void setSystolicBp(String? systolicBp) {
    state = state.copyWith(systolicBp: systolicBp);
  }

  void setDiastolicBp(String? diastolicBp) {
    state = state.copyWith(diastolicBp: diastolicBp);
  }

  void setHeartRate(String? heartRate) {
    state = state.copyWith(heartRate: heartRate);
  }

  void setRespiratoryRate(String? respiratoryRate) {
    state = state.copyWith(respiratoryRate: respiratoryRate);
  }

  void setTotalUrineVolume(String? totalUrineVolume) {
    state = state.copyWith(totalUrineVolume: totalUrineVolume);
  }

  void setTimeSinceCatheterHours(String? timeSinceCatheterHours) {
    state = state.copyWith(timeSinceCatheterHours: timeSinceCatheterHours);
  }

  void setMentalStatus(MentalStatus? mentalStatus) {
    state = state.copyWith(mentalStatus: mentalStatus);
  }

  void setBaseDeficit(String? baseDeficit) {
    state = state.copyWith(baseDeficit: baseDeficit);
  }

  void setEstimatedBloodLossPercent(String? estimatedBloodLossPercent) {
    state = state.copyWith(estimatedBloodLossPercent: estimatedBloodLossPercent);
  }

  void setEstimatedBloodLossMl(String? estimatedBloodLossMl) {
    state = state.copyWith(estimatedBloodLossMl: estimatedBloodLossMl);
  }

  void reset() {
    state = const AtlsShockFormState();
  }
}

final atlsShockFormProvider =
    StateNotifierProvider<AtlsShockFormNotifier, AtlsShockFormState>((ref) {
  return AtlsShockFormNotifier();
});

/// Calculation result provider
final atlsShockResultProvider =
    Provider.autoDispose<AtlsShockResult?>((ref) {
  final formState = ref.watch(atlsShockFormProvider);
  final repository = ref.watch(atlsShockRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  try {
    final age = formState.age != null && formState.age!.isNotEmpty
        ? int.parse(formState.age!)
        : null;
    final weightKg = formState.weightKg != null && formState.weightKg!.isNotEmpty
        ? double.parse(formState.weightKg!)
        : null;
    final systolicBp = double.parse(formState.systolicBp!);
    final diastolicBp = double.parse(formState.diastolicBp!);
    final heartRate = formState.heartRate != null && formState.heartRate!.isNotEmpty
        ? int.parse(formState.heartRate!)
        : null;
    final respiratoryRate = int.parse(formState.respiratoryRate!);
    final totalUrineVolume = formState.totalUrineVolume != null &&
            formState.totalUrineVolume!.isNotEmpty
        ? double.parse(formState.totalUrineVolume!)
        : null;
    final timeSinceCatheterHours = formState.timeSinceCatheterHours != null &&
            formState.timeSinceCatheterHours!.isNotEmpty
        ? double.parse(formState.timeSinceCatheterHours!)
        : null;
    final mentalStatus = formState.mentalStatus!;
    final baseDeficit = formState.baseDeficit != null &&
            formState.baseDeficit!.isNotEmpty
        ? double.parse(formState.baseDeficit!)
        : null;
    final estimatedBloodLossPercent = formState.estimatedBloodLossPercent != null &&
            formState.estimatedBloodLossPercent!.isNotEmpty
        ? double.parse(formState.estimatedBloodLossPercent!)
        : null;
    final estimatedBloodLossMl = formState.estimatedBloodLossMl != null &&
            formState.estimatedBloodLossMl!.isNotEmpty
        ? double.parse(formState.estimatedBloodLossMl!)
        : null;

    return repository.classify(
      age: age,
      weightKg: weightKg,
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      heartRate: heartRate,
      respiratoryRate: respiratoryRate,
      totalUrineVolume: totalUrineVolume,
      timeSinceCatheterHours: timeSinceCatheterHours,
      mentalStatus: mentalStatus,
      baseDeficit: baseDeficit,
      estimatedBloodLossPercent: estimatedBloodLossPercent,
      estimatedBloodLossMl: estimatedBloodLossMl,
    );
  } catch (e) {
    return null;
  }
});
