import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/egfr_calculator/presentation/providers/egfr_providers.dart';
import 'package:chemical_app/features/egfr_calculator/presentation/widgets/egfr_result_widget.dart';

class EgfrCalculatorScreen extends ConsumerStatefulWidget {
  const EgfrCalculatorScreen({super.key});

  @override
  ConsumerState<EgfrCalculatorScreen> createState() =>
      _EgfrCalculatorScreenState();
}

class _EgfrCalculatorScreenState extends ConsumerState<EgfrCalculatorScreen> {
  late final TextEditingController _creatinineController;
  late final TextEditingController _cystatinCController;
  late final TextEditingController _ageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _creatinineController = TextEditingController();
    _cystatinCController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _creatinineController.dispose();
    _cystatinCController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(egfrFormProvider);
    final result = ref.watch(egfrResultProvider);
    final formNotifier = ref.read(egfrFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_creatinineController.text != (formState.serumCreatinine ?? '')) {
      _creatinineController.text = formState.serumCreatinine ?? '';
    }
    if (_cystatinCController.text != (formState.cystatinC ?? '')) {
      _cystatinCController.text = formState.cystatinC ?? '';
    }
    if (_ageController.text != (formState.age ?? '')) {
      _ageController.text = formState.age ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('eGFR Calculator'),
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
                'eGFR Calculator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Estimate Glomerular Filtration Rate using CKD-EPI equations. Cystatin C improves accuracy when available.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Serum Creatinine',
                unit: 'μmol/L',
                controller: _creatinineController,
                validator: validateSerumCreatinine,
                onChanged: (value) => formNotifier.setSerumCreatinine(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Cystatin C',
                unit: 'mg/L',
                controller: _cystatinCController,
                validator: validateCystatinC,
                hintText: 'Optional (improves accuracy)',
                onChanged: (value) =>
                    formNotifier.setCystatinC(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Age',
                unit: 'years',
                controller: _ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Please enter a valid number';
                  }
                  if (age < 0 || age > 120) {
                    return 'Age must be between 0-120 years';
                  }
                  return null;
                },
                onChanged: (value) => formNotifier.setAge(value),
              ),
              const SizedBox(height: 16),
              Text(
                'Sex',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Male')),
                  ButtonSegment(value: false, label: Text('Female')),
                ],
                selected: {if (formState.isMale != null) formState.isMale!},
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<bool> selected) {
                  formNotifier.setIsMale(selected.firstOrNull);
                },
              ),
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
                          'Formula Selection',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Creatinine only: CKD-EPI 2021 equation\n'
                      '• Cystatin C only: CKD-EPI 2012 cystatin C equation\n'
                      '• Both available: CKD-EPI 2012 combined equation (most accurate)',
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
                EgfrResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
