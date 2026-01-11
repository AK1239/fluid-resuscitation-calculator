import 'package:chemical_app/core/constants/clinical_formulas.dart';
import 'package:chemical_app/features/maintenance_fluids/domain/entities/maintenance_fluid_result.dart';

/// Use case for calculating maintenance fluids
class CalculateMaintenanceFluids {
  /// Calculates maintenance fluids for a given weight
  MaintenanceFluidResult execute({required double weightKg}) {
    // Calculate daily maintenance
    final dailyTotal = calculateMaintenanceFluids(weightKg);

    // Calculate hourly rate
    final hourlyRate = calculateHourlyMaintenanceRate(dailyTotal);

    // Additional information (static text as per PRD)
    const additionalInfo = '''
Normal water input/output:
- Input: ~2500 mL/day (oral + IV)
- Output: ~2500 mL/day (urine, stool, insensible losses)

Factors increasing needs:
- Fever, burns, diarrhea, vomiting
- High-output states

Factors decreasing needs:
- Heart failure, renal failure
- SIADH, fluid overload

Suggested starter regimen:
- ½ NS + D5 + 20 mEq KCl per liter
- Adjust based on clinical context and lab values
''';

    return MaintenanceFluidResult(
      dailyTotal: dailyTotal,
      hourlyRate: hourlyRate,
      additionalInfo: additionalInfo,
    );
  }
}
