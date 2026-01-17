import 'package:flutter/material.dart';

class CalculatorListHeader extends StatelessWidget {
  final bool isSearching;
  final int resultCount;

  const CalculatorListHeader({
    super.key,
    required this.isSearching,
    required this.resultCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return Row(
        children: [
          Text(
            'Search Results',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text('$resultCount found'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
      );
    }

    return Text(
      'Select Calculator',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
