import 'package:flutter/material.dart';
import '../models/calculator_model.dart';

class CalculatorsRepository {
  static const List<CalculatorModel> allCalculators = [
    // General (uncategorized calculators)
    CalculatorModel(
      title: 'Maintenance Fluids',
      icon: Icons.medical_services,
      description: 'Calculate daily and hourly maintenance fluid rates',
      route: '/maintenance-fluids',
      category: 'General',
    ),
    CalculatorModel(
      title: 'Insulin Dosing',
      icon: Icons.medication,
      description: 'Calculate insulin dosing using 2/3-1/3 rule',
      route: '/insulin-dosing',
      category: 'General',
    ),
    CalculatorModel(
      title: 'BMI Calculator',
      icon: Icons.monitor_weight,
      description:
          'Calculate Body Mass Index with WHO classification and clinical interpretation',
      route: '/bmi-calculator',
      category: 'General',
    ),
    CalculatorModel(
      title: 'Maintenance Calories',
      icon: Icons.local_dining,
      description:
          'Calculate daily caloric requirements and equivalent IV dextrose volumes for maintenance',
      route: '/maintenance-calories',
      category: 'General',
    ),
    CalculatorModel(
      title: 'Iron Sucrose (IV)',
      icon: Icons.healing,
      description: 'Calculate iron sucrose dosing using Ganzoni formula',
      route: '/iron-sucrose',
      category: 'General',
    ),
    // Electrolyte Corrections
    CalculatorModel(
      title: 'Sodium Correction',
      icon: Icons.science,
      description: 'Calculate sodium correction and 3% Saline volume',
      route: '/sodium',
      category: 'Electrolyte Corrections',
    ),
    CalculatorModel(
      title: 'Potassium Correction',
      icon: Icons.science,
      description: 'Calculate potassium correction and Slow-K tablets',
      route: '/potassium',
      category: 'Electrolyte Corrections',
    ),
    CalculatorModel(
      title: 'Magnesium Correction',
      icon: Icons.science,
      description: 'Calculate magnesium correction dosing',
      route: '/magnesium',
      category: 'Electrolyte Corrections',
    ),
    CalculatorModel(
      title: 'Calcium Correction',
      icon: Icons.science,
      description: 'Calculate calcium correction dosing',
      route: '/calcium',
      category: 'Electrolyte Corrections',
    ),
    // Nephro
    CalculatorModel(
      title: 'Urine Output & AKI Staging',
      icon: Icons.water_drop_outlined,
      description:
          'Calculate urine output and KDIGO AKI staging based on urine volume measurements',
      route: '/urine-output-aki',
      category: 'Nephro',
    ),
    CalculatorModel(
      title: 'eGFR Calculator',
      icon: Icons.health_and_safety,
      description:
          'Estimate Glomerular Filtration Rate using CKD-EPI equations with CKD stage classification',
      route: '/egfr-calculator',
      category: 'Nephro',
    ),
    CalculatorModel(
      title: 'Creatinine Clearance',
      icon: Icons.medication,
      description:
          'Calculate creatinine clearance and determine drug dose adjustments for renal impairment',
      route: '/renal-dose-adjustment',
      category: 'Nephro',
    ),
    // Obgyn
    CalculatorModel(
      title: 'Bishop Score',
      icon: Icons.pregnant_woman,
      description:
          'Assess cervical favorability for induction of labor with evidence-based management guidance',
      route: '/bishop-score',
      category: 'Obgyn',
    ),
    CalculatorModel(
      title: 'Obstetric Calculator',
      icon: Icons.child_care,
      description: 'Calculate EDD using Naegele\'s rule and gestational age',
      route: '/obstetric-calculator',
      category: 'Obgyn',
    ),
    // Emergency
    CalculatorModel(
      title: 'Fluid Resuscitation',
      icon: Icons.water_drop,
      description: 'Calculate fluid deficit and resuscitation phases',
      route: '/fluid-resuscitation',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'Norepinephrine Infusion',
      icon: Icons.medication_liquid,
      description: 'Calculate norepinephrine infusion dosing and rate',
      route: '/norepinephrine',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'MAP & Pulse Pressure',
      icon: Icons.favorite,
      description:
          'Calculate Mean Arterial Pressure and Pulse Pressure with clinical interpretation',
      route: '/map-pulse-pressure',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'Shock Index Calculator',
      icon: Icons.emergency,
      description:
          'Calculate Shock Index (SI) and Trauma-Adjusted Shock Index (TASI) with risk stratification',
      route: '/shock-index',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'ATLS Shock Classification',
      icon: Icons.emergency_outlined,
      description:
          'Classify hemorrhagic shock using ATLS 10th Edition criteria with automatic parameter derivation',
      route: '/atls-shock-classification',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'Burn Resuscitation',
      icon: Icons.local_fire_department,
      description: 'Calculate fluid resuscitation using Parkland formula',
      route: '/burn-resuscitation',
      category: 'Emergency',
    ),
    CalculatorModel(
      title: 'WHO Growth Assessment',
      icon: Icons.height,
      description: 'Assess nutritional status using WHO Z-scores (0-59 months)',
      route: '/who-growth-assessment',
      category: 'Pediatrics',
    ),
    CalculatorModel(
      title: 'Developmental Screening',
      icon: Icons.psychology,
      description: 'Screen developmental milestones and flag delays',
      route: '/developmental-screening',
      category: 'Pediatrics',
    ),
    CalculatorModel(
      title: 'Pediatric Vitals',
      icon: Icons.favorite,
      description:
          'View pediatric vital signs reference charts (blood pressure, pulse rate, respiratory rate)',
      route: '/pediatric-vitals',
      category: 'Pediatrics',
    ),
    CalculatorModel(
      title: 'Premature Baby Fluid',
      icon: Icons.child_care_outlined,
      description:
          'Calculate IV fluid and feeding requirements for neonates based on MNH Clinical Guidelines',
      route: '/premature-baby-fluid',
      category: 'Pediatrics',
    ),
  ];
}
