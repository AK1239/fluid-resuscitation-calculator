import '../models/calculator_model.dart';

class CalculatorSearchService {
  static List<CalculatorModel> filterCalculators(
    List<CalculatorModel> calculators,
    String query,
  ) {
    if (query.isEmpty) {
      return calculators;
    }

    final lowerQuery = query.toLowerCase();
    return calculators
        .where((calc) =>
            calc.title.toLowerCase().contains(lowerQuery) ||
            calc.description.toLowerCase().contains(lowerQuery) ||
            calc.category.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static Map<String, List<CalculatorModel>> groupByCategory(
    List<CalculatorModel> calculators,
  ) {
    final Map<String, List<CalculatorModel>> grouped = {};
    for (final calc in calculators) {
      grouped.putIfAbsent(calc.category, () => []).add(calc);
    }
    return grouped;
  }

  static List<String> sortCategories(List<String> categories) {
    final order = ['General', 'Electrolyte Corrections', 'Pediatrics'];
    return categories..sort((a, b) {
        final indexA = order.indexOf(a);
        final indexB = order.indexOf(b);
        if (indexA == -1 && indexB == -1) return a.compareTo(b);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
  }
}
