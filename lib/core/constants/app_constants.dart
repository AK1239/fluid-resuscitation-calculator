/// App-wide constants

class AppConstants {
  // Disclaimer text
  static const String disclaimerText =
      'This app is for educational use only and does not replace clinical judgment.';

  // App name
  static const String appName = 'Fluid Resuscitation Calculator';

  // SharedPreferences keys
  static const String disclaimerAcceptedKey = 'disclaimer_accepted';

  // Default values
  static const double defaultWeight = 70.0; // kg
  static const double defaultSodium = 140.0; // mEq/L
  static const double defaultPotassium = 4.0; // mEq/L
  static const double defaultMagnesium = 2.0; // mg/dL
  static const double defaultCalcium = 2.5; // mmol/L

  // Clinical reference ranges (for display/info purposes)
  static const double normalSodiumMin = 135.0;
  static const double normalSodiumMax = 145.0;
  static const double normalPotassiumMin = 3.5;
  static const double normalPotassiumMax = 5.0;
  static const double normalMagnesiumMin = 1.7;
  static const double normalMagnesiumMax = 2.2;
  static const double normalCalciumMin = 2.1; // mmol/L
  static const double normalCalciumMax = 2.6; // mmol/L
}

