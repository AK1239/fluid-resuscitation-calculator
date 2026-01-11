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

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/disclaimer',
      builder: (context, state) => const DisclaimerScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
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
  ],
);

