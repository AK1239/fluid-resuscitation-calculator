import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chemical_app/features/bishop_score/data/repositories/bishop_score_repository_impl.dart';
import 'package:chemical_app/features/bishop_score/domain/entities/bishop_score_result.dart';

/// Repository provider
final bishopScoreRepositoryProvider =
    Provider<BishopScoreRepositoryImpl>((ref) {
  return BishopScoreRepositoryImpl();
});

/// Form state
class BishopScoreFormState {
  final CervicalDilation? dilation;
  final CervicalEffacement? effacement;
  final FetalStation? station;
  final CervicalConsistency? consistency;
  final CervicalPosition? position;

  const BishopScoreFormState({
    this.dilation,
    this.effacement,
    this.station,
    this.consistency,
    this.position,
  });

  BishopScoreFormState copyWith({
    CervicalDilation? dilation,
    CervicalEffacement? effacement,
    FetalStation? station,
    CervicalConsistency? consistency,
    CervicalPosition? position,
  }) {
    return BishopScoreFormState(
      dilation: dilation ?? this.dilation,
      effacement: effacement ?? this.effacement,
      station: station ?? this.station,
      consistency: consistency ?? this.consistency,
      position: position ?? this.position,
    );
  }

  bool get isValid {
    return dilation != null &&
        effacement != null &&
        station != null &&
        consistency != null &&
        position != null;
  }
}

/// Form state notifier
class BishopScoreFormNotifier
    extends StateNotifier<BishopScoreFormState> {
  BishopScoreFormNotifier() : super(const BishopScoreFormState());

  void setDilation(CervicalDilation? dilation) {
    state = state.copyWith(dilation: dilation);
  }

  void setEffacement(CervicalEffacement? effacement) {
    state = state.copyWith(effacement: effacement);
  }

  void setStation(FetalStation? station) {
    state = state.copyWith(station: station);
  }

  void setConsistency(CervicalConsistency? consistency) {
    state = state.copyWith(consistency: consistency);
  }

  void setPosition(CervicalPosition? position) {
    state = state.copyWith(position: position);
  }

  void reset() {
    state = const BishopScoreFormState();
  }
}

final bishopScoreFormProvider =
    StateNotifierProvider<BishopScoreFormNotifier, BishopScoreFormState>(
        (ref) {
  return BishopScoreFormNotifier();
});

/// Calculation result provider
final bishopScoreResultProvider =
    Provider.autoDispose<BishopScoreResult?>((ref) {
  final formState = ref.watch(bishopScoreFormProvider);
  final repository = ref.watch(bishopScoreRepositoryProvider);

  if (!formState.isValid) {
    return null;
  }

  return repository.calculate(
    dilation: formState.dilation!,
    effacement: formState.effacement!,
    station: formState.station!,
    consistency: formState.consistency!,
    position: formState.position!,
  );
});