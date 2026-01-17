import 'package:chemical_app/features/map_pulse_pressure/domain/entities/map_pulse_pressure_result.dart';
import 'package:chemical_app/features/map_pulse_pressure/domain/use_cases/calculate_map_pulse_pressure.dart';

/// Repository implementation for MAP and Pulse Pressure calculation
class MapPulsePressureRepositoryImpl {
  final CalculateMapPulsePressure _calculateMapPulsePressure;

  MapPulsePressureRepositoryImpl({
    CalculateMapPulsePressure? calculateMapPulsePressure,
  }) : _calculateMapPulsePressure =
            calculateMapPulsePressure ?? CalculateMapPulsePressure();

  /// Calculates MAP and Pulse Pressure
  MapPulsePressureResult calculate({
    required double systolicBp,
    required double diastolicBp,
  }) {
    return _calculateMapPulsePressure.execute(
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
    );
  }
}
