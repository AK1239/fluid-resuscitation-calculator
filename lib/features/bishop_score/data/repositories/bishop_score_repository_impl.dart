import 'package:chemical_app/features/bishop_score/domain/entities/bishop_score_result.dart';
import 'package:chemical_app/features/bishop_score/domain/use_cases/calculate_bishop_score.dart';

/// Repository implementation for Bishop score calculation
class BishopScoreRepositoryImpl {
  final CalculateBishopScore _calculateBishopScore;

  BishopScoreRepositoryImpl({CalculateBishopScore? calculateBishopScore})
    : _calculateBishopScore = calculateBishopScore ?? CalculateBishopScore();

  /// Calculates Bishop score
  BishopScoreResult calculate({
    required CervicalDilation dilation,
    required CervicalEffacement effacement,
    required FetalStation station,
    required CervicalConsistency consistency,
    required CervicalPosition position,
  }) {
    return _calculateBishopScore.execute(
      dilation: dilation,
      effacement: effacement,
      station: station,
      consistency: consistency,
      position: position,
    );
  }
}
