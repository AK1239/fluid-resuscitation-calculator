import 'package:flutter/material.dart';

class CalculatorModel {
  final String title;
  final IconData icon;
  final String description;
  final String route;
  final String category;

  const CalculatorModel({
    required this.title,
    required this.icon,
    required this.description,
    required this.route,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          route == other.route;

  @override
  int get hashCode => title.hashCode ^ route.hashCode;
}
