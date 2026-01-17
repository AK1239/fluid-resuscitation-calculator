import 'package:chemical_app/features/bishop_score/domain/entities/bishop_score_result.dart';

/// Use case for calculating Bishop score
class CalculateBishopScore {
  /// Gets the score for cervical dilation (0-3)
  int _getDilationScore(CervicalDilation dilation) {
    switch (dilation) {
      case CervicalDilation.zero:
        return 0;
      case CervicalDilation.oneToTwo:
        return 1;
      case CervicalDilation.threeToFour:
        return 2;
      case CervicalDilation.fiveOrMore:
        return 3;
    }
  }

  /// Gets the score for cervical effacement (0-3)
  int _getEffacementScore(CervicalEffacement effacement) {
    switch (effacement) {
      case CervicalEffacement.zeroToThirty:
        return 0;
      case CervicalEffacement.fortyToFifty:
        return 1;
      case CervicalEffacement.sixtyToSeventy:
        return 2;
      case CervicalEffacement.eightyOrMore:
        return 3;
    }
  }

  /// Gets the score for fetal station (0-3)
  int _getStationScore(FetalStation station) {
    switch (station) {
      case FetalStation.minusThree:
        return 0;
      case FetalStation.minusTwo:
        return 1;
      case FetalStation.minusOneOrZero:
        return 2;
      case FetalStation.plusOneOrTwo:
        return 3;
    }
  }

  /// Gets the score for cervical consistency (0-2)
  int _getConsistencyScore(CervicalConsistency consistency) {
    switch (consistency) {
      case CervicalConsistency.firm:
        return 0;
      case CervicalConsistency.medium:
        return 1;
      case CervicalConsistency.soft:
        return 2;
    }
  }

  /// Gets the score for cervical position (0-2)
  int _getPositionScore(CervicalPosition position) {
    switch (position) {
      case CervicalPosition.posterior:
        return 0;
      case CervicalPosition.midPosition:
        return 1;
      case CervicalPosition.anterior:
        return 2;
    }
  }

  /// Executes the Bishop score calculation
  BishopScoreResult execute({
    required CervicalDilation dilation,
    required CervicalEffacement effacement,
    required FetalStation station,
    required CervicalConsistency consistency,
    required CervicalPosition position,
  }) {
    final dilationScore = _getDilationScore(dilation);
    final effacementScore = _getEffacementScore(effacement);
    final stationScore = _getStationScore(station);
    final consistencyScore = _getConsistencyScore(consistency);
    final positionScore = _getPositionScore(position);

    final totalScore = dilationScore +
        effacementScore +
        stationScore +
        consistencyScore +
        positionScore;

    final isFavourable = totalScore >= 6;

    return BishopScoreResult(
      dilation: dilation,
      effacement: effacement,
      station: station,
      consistency: consistency,
      position: position,
      totalScore: totalScore,
      isFavourable: isFavourable,
    );
  }
}