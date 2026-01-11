Product Requirements Document (PRD)
Project: Fluid Resuscitation Calculator (Android APK)

1. Product Overview

A simple, offline-first medical calculator app designed to help clinicians or students quickly calculate:

Fluid deficit

Fluid resuscitation phases

Maintenance fluids

Electrolyte corrections (Na, K, Mg, Ca)

The app is not a reference textbook — it is a fast calculation + guidance tool based on predefined clinical formulas.

Target output: Single Android APK, clean UI, fast, reliable.

2. Target Users

Medical students

Interns / junior doctors

Clinical officers

Nurses (basic use)

3. Core Principles

⚡ Fast calculations

🧠 Minimal cognitive load

🧩 Modular & maintainable code

🏗️ Clean Architecture

🎨 Clean, modern, medical-grade UI

📴 Works fully offline

⚠️ Educational tool (clear disclaimer)

4. App Scope (STRICT MVP)
   INCLUDED

✔ Fluid resuscitation calculations
✔ Maintenance fluid calculations
✔ Electrolyte correction calculators
✔ Adult vs Pediatric logic
✔ Clear step-by-step output
✔ Android only

EXCLUDED (Out of Scope)

❌ User accounts
❌ Backend / API
❌ Patient storage
❌ Cloud sync
❌ iOS / Web

5. Functional Modules
   5.1 Fluid Resuscitation Module
   Inputs

Patient type: Adult / Pediatric

Body weight (kg)

% dehydration (selectable: Mild / Moderate / Severe)

Logic

% ranges differ for adult vs pediatric

Formula:

Fluid deficit (mL) = 10 × weight (kg) × % dehydration

Output

Total fluid deficit (mL)

Phase 1:

½ deficit over 30 minutes

Phase 2:

Maintenance + ¼ deficit over 8 hours

Phase 3:

Maintenance + ¼ deficit over 16 hours

5.2 Maintenance Fluids Module
Adult Maintenance

Default:

35 mL/kg/day

Show:

Daily total (mL)

Hourly rate (mL/hr)

Additional Info (Display-only)

Normal water input/output

Factors increasing/decreasing needs

Suggested starter regimen (½ NS + D5 + KCl)

⚠️ No dynamic lab-based adjustments (keep MVP simple)

5.3 Electrolyte Calculators Module

Each electrolyte is a separate calculator screen.

5.3.1 Sodium Correction
Inputs

Sex (Male / Female)

Weight (kg)

Current Na

Target Na

Logic
Male: 0.6 × BW × (target − current)
Female: 0.5 × BW × (target − current)

Output

Total sodium required (mEq)

Equivalent volume of 3% NS

5.3.2 Potassium Correction
Inputs

Current K

Target K

Logic

Apply 1.5× deficit rule

Display oral vs IV guidance (static text)

Output

Required mmol K

Approx number of Slow-K tablets

IV suggestion (display-only, no dosing automation)

5.3.3 Magnesium Correction
Inputs

Current Mg

Symptomatic? (Yes / No)

Output

Suggested IV dosing ranges

Expected serum rise

Monitoring reminders

⚠️ Rule-based output, not automation

5.3.4 Calcium Correction
Inputs

Weight

Current Ca

Symptomatic? (Yes / No)

Output

Estimated calcium deficit

IV calcium gluconate guidance

Oral supplementation info

6. App Screens (Simple)

Splash / Disclaimer screen

Home dashboard (cards):

Fluid Resuscitation

Maintenance Fluids

Sodium

Potassium

Magnesium

Calcium

Individual calculator screens

Results screen (clear, structured, copy-friendly)

7. UI / UX Guidelines
   Design Style

Clean medical aesthetic

White / light gray background

One primary accent color (blue or teal)

Rounded cards

Large readable numbers

Minimal text clutter

UX Rules

One task per screen

Large input fields

No scrolling overload

Clear units everywhere (kg, mL, mEq)

Results visually separated by sections

8. Architecture (VERY IMPORTANT)
   Clean Architecture Layers
   lib/
   ├── core/
   │ ├── constants/
   │ ├── utils/
   │ └── widgets/
   │
   ├── features/
   │ ├── fluid_resuscitation/
   │ │ ├── presentation/
   │ │ ├── domain/
   │ │ └── data/
   │ │
   │ ├── maintenance_fluids/
   │ ├── electrolytes/
   │ │ ├── sodium/
   │ │ ├── potassium/
   │ │ ├── magnesium/
   │ │ └── calcium/
   │
   ├── app/
   │ ├── router.dart
   │ └── theme.dart
   │
   └── main.dart

State Management

✅ Riverpod (preferred)
OR
✅ Bloc (if needed, but keep lightweight)

No Provider-only spaghetti.

Domain Layer

Pure Dart

All formulas live here

Fully testable

No Flutter imports

Presentation Layer

Stateless widgets where possible

Form validation

Result rendering

9. Best Practices

Null safety everywhere

Strong typing

Centralized constants for formulas

No magic numbers in UI

Clear comments for clinical logic

Separation of UI and calculations

10. Safety & Disclaimer

Disclaimer shown on first launch:

“This app is for educational use only and does not replace clinical judgment.”

11. Build & Delivery

Android only

Release APK

No Play Store publishing (initially)
