# Med Calculator

A comprehensive medical calculator app designed for healthcare professionals, medical students, and clinical officers. The app provides quick calculations for fluid resuscitation, electrolyte corrections, and pediatric assessments.

## Features

### Fluid & Resuscitation Calculators
- **Fluid Resuscitation** - Calculate fluid deficit and resuscitation phases for adults and pediatrics
- **Maintenance Fluids** - Calculate daily and hourly maintenance fluid rates
- **Burn Resuscitation** - Calculate fluid resuscitation using Parkland formula (adult and pediatric)

### Electrolyte Corrections
- **Sodium Correction** - Calculate sodium deficit and 3% Saline volume
- **Potassium Correction** - Calculate potassium correction and Slow-K tablets
- **Magnesium Correction** - Calculate magnesium correction dosing
- **Calcium Correction** - Calculate calcium correction dosing

### Pediatric Tools
- **WHO Growth Assessment** - View WHO growth charts for children (0-59 months)
- **Pediatric Vitals** - Reference charts for blood pressure, pulse rate, and respiratory rate
- **Developmental Screening** - Screen developmental milestones and flag delays

### Other Medical Calculators
- **Insulin Dosing** - Calculate insulin dosing using 2/3-1/3 rule
- **Iron Sucrose (IV)** - Calculate iron sucrose dosing using Ganzoni formula
- **Obstetric Calculator** - Calculate EDD using Naegele's rule and gestational age

## Key Features

- ✅ **Offline-First** - Works completely offline, no internet connection required
- ✅ **Fast Calculations** - Quick, accurate calculations based on established clinical formulas
- ✅ **Clean UI** - Medical-grade, easy-to-use interface
- ✅ **Comprehensive** - Multiple calculators in one convenient app
- ✅ **Educational Tool** - Designed for learning and quick reference

## Disclaimer

**⚠️ Important:** This app is for educational use only and does not replace clinical judgment. Always consult with qualified healthcare professionals for clinical decisions.

## Installation

### Building from Source

1. Ensure you have Flutter installed (SDK ^3.9.0)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the app

### Building Release APK

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

For a split APK (smaller file size):
```bash
flutter build apk --split-per-abi
```

## Technical Details

- **Framework:** Flutter
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Package ID:** `tz.medtutor.fluidcalculator`
- **Minimum Android SDK:** 21

## Project Structure

```
lib/
├── app/              # App-level configuration (router, theme, screens)
├── core/             # Core utilities, constants, widgets
└── features/         # Feature modules
    ├── fluid_resuscitation/
    ├── electrolytes/
    ├── pediatric_vitals/
    └── ...
```

## Development

This project follows Clean Architecture principles with feature-based organization. Each feature module contains:
- `presentation/` - UI and state management
- `domain/` - Business logic and entities
- `data/` - Data sources and repositories

## License

This project is for educational purposes. Please ensure all clinical calculations are verified by qualified healthcare professionals before use in clinical settings.

## Support

For questions or issues, please contact the development team.

---

**Version:** 1.0.0  
**Package:** tz.medtutor.fluidcalculator  
**Platform:** Android
