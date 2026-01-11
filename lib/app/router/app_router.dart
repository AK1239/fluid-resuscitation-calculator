import 'package:go_router/go_router.dart';
import 'package:chemical_app/app/screens/splash_screen.dart';
import 'package:chemical_app/app/screens/disclaimer_screen.dart';
import 'package:chemical_app/app/screens/home_screen.dart';
import 'package:chemical_app/features/fluid_resuscitation/presentation/screens/fluid_resuscitation_screen.dart';
import 'package:chemical_app/features/maintenance_fluids/presentation/screens/maintenance_fluid_screen.dart';
import 'package:chemical_app/features/electrolytes/sodium/presentation/screens/sodium_correction_screen.dart';
import 'package:chemical_app/features/electrolytes/potassium/presentation/screens/potassium_correction_screen.dart';
import 'package:chemical_app/features/electrolytes/magnesium/presentation/screens/magnesium_correction_screen.dart';
import 'package:chemical_app/features/electrolytes/calcium/presentation/screens/calcium_correction_screen.dart';
import 'package:chemical_app/features/insulin_dosing/presentation/screens/insulin_dosing_screen.dart';
import 'package:chemical_app/features/obstetric_calculator/presentation/screens/obstetric_calculator_screen.dart';
import 'package:chemical_app/features/who_growth_assessment/presentation/screens/who_growth_assessment_screen.dart';
import 'package:chemical_app/features/iron_sucrose/presentation/screens/iron_sucrose_screen.dart';
import 'package:chemical_app/features/developmental_screening/presentation/screens/developmental_screening_screen.dart';
import 'package:chemical_app/features/burn_resuscitation/presentation/screens/burn_resuscitation_screen.dart';
import 'package:chemical_app/features/burn_resuscitation/presentation/screens/burn_resuscitation_selection_screen.dart';
import 'package:chemical_app/features/pediatric_burn_resuscitation/presentation/screens/pediatric_burn_resuscitation_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/pediatric_vitals_selection_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/pulse_respiratory_rate_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/blood_pressure_selection_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/blood_pressure_male_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/blood_pressure_female_screen.dart';
import 'package:chemical_app/features/pediatric_vitals/presentation/screens/blood_pressure_interpretation_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/disclaimer',
      builder: (context, state) => const DisclaimerScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/fluid-resuscitation',
      builder: (context, state) => const FluidResuscitationScreen(),
    ),
    GoRoute(
      path: '/maintenance-fluids',
      builder: (context, state) => const MaintenanceFluidScreen(),
    ),
    GoRoute(
      path: '/sodium',
      builder: (context, state) => const SodiumCorrectionScreen(),
    ),
    GoRoute(
      path: '/potassium',
      builder: (context, state) => const PotassiumCorrectionScreen(),
    ),
    GoRoute(
      path: '/magnesium',
      builder: (context, state) => const MagnesiumCorrectionScreen(),
    ),
    GoRoute(
      path: '/calcium',
      builder: (context, state) => const CalciumCorrectionScreen(),
    ),
    GoRoute(
      path: '/insulin-dosing',
      builder: (context, state) => const InsulinDosingScreen(),
    ),
    GoRoute(
      path: '/obstetric-calculator',
      builder: (context, state) => const ObstetricCalculatorScreen(),
    ),
    GoRoute(
      path: '/who-growth-assessment',
      builder: (context, state) => const WhoGrowthAssessmentScreen(),
    ),
    GoRoute(
      path: '/iron-sucrose',
      builder: (context, state) => const IronSucroseScreen(),
    ),
    GoRoute(
      path: '/developmental-screening',
      builder: (context, state) => const DevelopmentalScreeningScreen(),
    ),
    GoRoute(
      path: '/burn-resuscitation',
      builder: (context, state) => const BurnResuscitationSelectionScreen(),
    ),
    GoRoute(
      path: '/burn-resuscitation/adult',
      builder: (context, state) => const BurnResuscitationScreen(),
    ),
    GoRoute(
      path: '/burn-resuscitation/pediatric',
      builder: (context, state) => const PediatricBurnResuscitationScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals',
      builder: (context, state) => const PediatricVitalsSelectionScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals/pulse-respiratory-rate',
      builder: (context, state) => const PulseRespiratoryRateScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals/blood-pressure',
      builder: (context, state) => const BloodPressureSelectionScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals/blood-pressure/male',
      builder: (context, state) => const BloodPressureMaleScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals/blood-pressure/female',
      builder: (context, state) => const BloodPressureFemaleScreen(),
    ),
    GoRoute(
      path: '/pediatric-vitals/blood-pressure/interpretation',
      builder: (context, state) => const BloodPressureInterpretationScreen(),
    ),
  ],
);
