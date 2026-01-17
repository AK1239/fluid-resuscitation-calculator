import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import 'calculator_card.dart';

class CalculatorCategorySection extends StatelessWidget {
  final String category;
  final List<CalculatorModel> calculators;
  final bool showCategoryTitle;
  final ValueChanged<String> onCalculatorTap;

  const CalculatorCategorySection({
    super.key,
    required this.category,
    required this.calculators,
    required this.showCategoryTitle,
    required this.onCalculatorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCategoryTitle) ...[
          const SizedBox(height: 24),
          Text(
            category,
            style: category == 'General' || category == 'Pediatrics'
                ? Theme.of(context).textTheme.headlineMedium
                : Theme.of(context).textTheme.titleLarge,
          ),
          if (category == 'Electrolyte Corrections' || category == 'Pediatrics')
            const SizedBox(height: 16),
        ] else
          const SizedBox(height: 16),
        ...calculators.map(
          (calc) => CalculatorCard(
            title: calc.title,
            icon: calc.icon,
            description: calc.description,
            onTap: () => onCalculatorTap(calc.route),
          ),
        ),
      ],
    );
  }
}
