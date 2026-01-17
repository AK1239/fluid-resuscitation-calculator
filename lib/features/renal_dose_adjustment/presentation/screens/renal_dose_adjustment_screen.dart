import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/renal_dose_adjustment/presentation/providers/renal_dose_adjustment_providers.dart';
import 'package:chemical_app/features/renal_dose_adjustment/presentation/widgets/renal_dose_adjustment_result_widget.dart';

class RenalDoseAdjustmentScreen extends ConsumerStatefulWidget {
  const RenalDoseAdjustmentScreen({super.key});

  @override
  ConsumerState<RenalDoseAdjustmentScreen> createState() =>
      _RenalDoseAdjustmentScreenState();
}

class _RenalDoseAdjustmentScreenState
    extends ConsumerState<RenalDoseAdjustmentScreen> {
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _creatinineController;
  late final TextEditingController _standardDoseController;
  late final TextEditingController _standardIntervalController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _creatinineController = TextEditingController();
    _standardDoseController = TextEditingController();
    _standardIntervalController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _creatinineController.dispose();
    _standardDoseController.dispose();
    _standardIntervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(renalDoseAdjustmentFormProvider);
    final result = ref.watch(renalDoseAdjustmentResultProvider);
    final formNotifier = ref.read(renalDoseAdjustmentFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_ageController.text != (formState.age ?? '')) {
      _ageController.text = formState.age ?? '';
    }
    if (_weightController.text != (formState.weightKg ?? '')) {
      _weightController.text = formState.weightKg ?? '';
    }
    if (_creatinineController.text != (formState.serumCreatinine ?? '')) {
      _creatinineController.text = formState.serumCreatinine ?? '';
    }
    if (_standardDoseController.text != (formState.standardDose ?? '')) {
      _standardDoseController.text = formState.standardDose ?? '';
    }
    if (_standardIntervalController.text != (formState.standardInterval ?? '')) {
      _standardIntervalController.text = formState.standardInterval ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renal Dose Adjustment'),
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
                'Renal Dose Adjustment Calculator',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate creatinine clearance and determine appropriate drug dose adjustments for renal impairment',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Patient Age',
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
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Weight',
                unit: 'kg',
                controller: _weightController,
                validator: validateWeight,
                onChanged: (value) => formNotifier.setWeightKg(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Serum Creatinine',
                unit: 'μmol/L',
                controller: _creatinineController,
                validator: validateSerumCreatinine,
                hintText: 'App will convert to mg/dL automatically',
                onChanged: (value) => formNotifier.setSerumCreatinine(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Standard Drug Dose',
                unit: 'mg',
                controller: _standardDoseController,
                validator: validateStandardDose,
                onChanged: (value) => formNotifier.setStandardDose(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Standard Dosing Interval',
                unit: 'hours',
                controller: _standardIntervalController,
                validator: validateStandardInterval,
                onChanged: (value) => formNotifier.setStandardInterval(value),
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
                          'About This Calculator',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This calculator uses the Cockcroft-Gault equation to estimate creatinine clearance. Serum creatinine is automatically converted from μmol/L to mg/dL. Dose adjustments are general guidelines; always consult drug-specific dosing references.',
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
                RenalDoseAdjustmentResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
