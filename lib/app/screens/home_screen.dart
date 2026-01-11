import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluid Resuscitation Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Calculator',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _CalculatorCard(
                title: 'Fluid Resuscitation',
                icon: Icons.water_drop,
                description: 'Calculate fluid deficit and resuscitation phases',
                onTap: () => context.go('/fluid-resuscitation'),
              ),
              _CalculatorCard(
                title: 'Maintenance Fluids',
                icon: Icons.medical_services,
                description: 'Calculate daily and hourly maintenance fluid rates',
                onTap: () => context.go('/maintenance-fluids'),
              ),
              _CalculatorCard(
                title: 'Insulin Dosing',
                icon: Icons.medication,
                description: 'Calculate insulin dosing using 2/3-1/3 rule',
                onTap: () => context.go('/insulin-dosing'),
              ),
              _CalculatorCard(
                title: 'Obstetric Calculator',
                icon: Icons.child_care,
                description: 'Calculate EDD using Naegele\'s rule and gestational age',
                onTap: () => context.go('/obstetric-calculator'),
              ),
              _CalculatorCard(
                title: 'WHO Growth Assessment',
                icon: Icons.height,
                description: 'Assess nutritional status using WHO Z-scores (0-59 months)',
                onTap: () => context.go('/who-growth-assessment'),
              ),
              const SizedBox(height: 16),
              Text(
                'Electrolyte Corrections',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _CalculatorCard(
                title: 'Sodium Correction',
                icon: Icons.science,
                description: 'Calculate sodium correction and 3% NS volume',
                onTap: () => context.go('/sodium'),
              ),
              _CalculatorCard(
                title: 'Potassium Correction',
                icon: Icons.science,
                description: 'Calculate potassium correction and Slow-K tablets',
                onTap: () => context.go('/potassium'),
              ),
              _CalculatorCard(
                title: 'Magnesium Correction',
                icon: Icons.science,
                description: 'Calculate magnesium correction dosing',
                onTap: () => context.go('/magnesium'),
              ),
              _CalculatorCard(
                title: 'Calcium Correction',
                icon: Icons.science,
                description: 'Calculate calcium correction dosing',
                onTap: () => context.go('/calcium'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _CalculatorCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

