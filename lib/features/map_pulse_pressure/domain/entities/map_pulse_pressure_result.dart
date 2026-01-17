/// Entity representing MAP and Pulse Pressure calculation result
class MapPulsePressureResult {
  final double systolicBp;
  final double diastolicBp;
  final double pulsePressure;
  final double meanArterialPressure;
  final PulsePressureInterpretation pulsePressureInterpretation;
  final MapInterpretation mapInterpretation;

  const MapPulsePressureResult({
    required this.systolicBp,
    required this.diastolicBp,
    required this.pulsePressure,
    required this.meanArterialPressure,
    required this.pulsePressureInterpretation,
    required this.mapInterpretation,
  });
}

/// Pulse Pressure interpretation categories
enum PulsePressureInterpretation {
  narrow, // PP < 25
  normal, // PP 30-50
  wide, // PP ≥ 60
}

/// MAP interpretation categories
enum MapInterpretation {
  low, // MAP < 65
  borderline, // MAP 65-70
  adequate, // MAP ≥ 65 (but typically shown as adequate when ≥ 70)
}
