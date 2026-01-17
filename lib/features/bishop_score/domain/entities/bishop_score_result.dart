/// Entity representing Bishop score calculation result
class BishopScoreResult {
  final CervicalDilation dilation;
  final CervicalEffacement effacement;
  final FetalStation station;
  final CervicalConsistency consistency;
  final CervicalPosition position;
  final int totalScore;
  final bool isFavourable; // true if score >= 6

  const BishopScoreResult({
    required this.dilation,
    required this.effacement,
    required this.station,
    required this.consistency,
    required this.position,
    required this.totalScore,
    required this.isFavourable,
  });
}

/// Cervical dilation options
enum CervicalDilation {
  zero, // 0 cm
  oneToTwo, // 1-2 cm
  threeToFour, // 3-4 cm
  fiveOrMore, // ≥5 cm
}

/// Cervical effacement options
enum CervicalEffacement {
  zeroToThirty, // 0-30%
  fortyToFifty, // 40-50%
  sixtyToSeventy, // 60-70%
  eightyOrMore, // ≥80%
}

/// Fetal station options
enum FetalStation {
  minusThree, // -3
  minusTwo, // -2
  minusOneOrZero, // -1 or 0
  plusOneOrTwo, // +1 or +2
}

/// Cervical consistency options
enum CervicalConsistency {
  firm,
  medium,
  soft,
}

/// Cervical position options
enum CervicalPosition {
  posterior,
  midPosition,
  anterior,
}