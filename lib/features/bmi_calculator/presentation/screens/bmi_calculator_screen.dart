import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/features/bmi_calculator/presentation/providers/bmi_providers.dart';
import 'package:chemical_app/features/bmi_calculator/presentation/widgets/bmi_result_widget.dart';

class BmiCalculatorScreen extends ConsumerStatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  ConsumerState<BmiCalculatorScreen> createState() =>
      _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends ConsumerState<BmiCalculatorScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _heightInchesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
    _heightInchesController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _heightInchesController.dispose();
    super.dispose();
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    if (weight > 500) {
      return 'Weight seems unrealistic (max 500 kg)';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }
    if (height <= 0) {
      return 'Height must be greater than 0';
    }
    return null;
  }

  String? _validateHeightInches(String? value, String? heightUnit) {
    if (heightUnit != 'ft/in') {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Inches is required';
    }
    final inches = int.tryParse(value);
    if (inches == null) {
      return 'Please enter a valid number';
    }
    if (inches < 0 || inches >= 12) {
      return 'Inches must be between 0-11';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(bmiFormProvider);
    final result = ref.watch(bmiResultProvider);
    final formNotifier = ref.read(bmiFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_heightController.text != (formState.height ?? '')) {
      _heightController.text = formState.height ?? '';
    }
    if (_heightInchesController.text != (formState.heightInches ?? '')) {
      _heightInchesController.text = formState.heightInches ?? '';
    }

    final showFeetInchesInput = formState.heightUnit == 'ft/in';

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI Calculator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate Body Mass Index using weight and height',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              // Weight unit selector
              Text(
                'Weight Unit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'kg', label: Text('kg')),
                  ButtonSegment(value: 'lb', label: Text('lb')),
                ],
                selected: {
                  if (formState.weightUnit != null) formState.weightUnit!,
                },
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<String> selected) {
                  formNotifier.setWeightUnit(selected.firstOrNull);
                },
              ),
              const SizedBox(height: 16),
              // Weight input
              CustomTextField(
                label: 'Weight',
                unit: formState.weightUnit ?? 'kg',
                controller: _weightController,
                validator: _validateWeight,
                onChanged: (value) => formNotifier.setWeight(value),
              ),
              const SizedBox(height: 24),
              // Height unit selector
              Text(
                'Height Unit',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'cm', label: Text('cm')),
                  ButtonSegment(value: 'm', label: Text('m')),
                  ButtonSegment(value: 'ft/in', label: Text('ft/in')),
                ],
                selected: {
                  if (formState.heightUnit != null) formState.heightUnit!,
                },
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<String> selected) {
                  formNotifier.setHeightUnit(selected.firstOrNull);
                },
              ),
              const SizedBox(height: 16),
              // Height input
              if (showFeetInchesInput) ...[
                // Feet input
                CustomTextField(
                  label: 'Height (Feet)',
                  unit: 'ft',
                  controller: _heightController,
                  validator: _validateHeight,
                  onChanged: (value) => formNotifier.setHeight(value),
                ),
                const SizedBox(height: 16),
                // Inches input
                CustomTextField(
                  label: 'Height (Inches)',
                  unit: 'in',
                  controller: _heightInchesController,
                  validator: (value) =>
                      _validateHeightInches(value, formState.heightUnit),
                  onChanged: (value) => formNotifier.setHeightInches(value),
                ),
              ] else ...[
                CustomTextField(
                  label: 'Height',
                  unit: formState.heightUnit ?? 'cm',
                  controller: _heightController,
                  validator: _validateHeight,
                  onChanged: (value) => formNotifier.setHeight(value),
                ),
              ],
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About This Calculator',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This calculator uses the Body Mass Index (BMI) formula: BMI = weight (kg) ÷ [height (m)]². Units are automatically converted as needed. BMI is classified according to WHO guidelines.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (result != null) ...[
                const Divider(),
                const SizedBox(height: 16),
                BmiResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
