import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/atls_shock_classification/presentation/providers/atls_shock_providers.dart';
import 'package:chemical_app/features/atls_shock_classification/presentation/widgets/atls_shock_result_widget.dart';
import 'package:chemical_app/features/atls_shock_classification/domain/entities/atls_shock_result.dart';

class AtlsShockClassificationScreen extends ConsumerStatefulWidget {
  const AtlsShockClassificationScreen({super.key});

  @override
  ConsumerState<AtlsShockClassificationScreen> createState() =>
      _AtlsShockClassificationScreenState();
}

class _AtlsShockClassificationScreenState
    extends ConsumerState<AtlsShockClassificationScreen> {
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _systolicBpController;
  late final TextEditingController _diastolicBpController;
  late final TextEditingController _heartRateController;
  late final TextEditingController _respiratoryRateController;
  late final TextEditingController _urineVolumeController;
  late final TextEditingController _timeSinceCatheterController;
  late final TextEditingController _baseDeficitController;
  late final TextEditingController _bloodLossPercentController;
  late final TextEditingController _bloodLossMlController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _systolicBpController = TextEditingController();
    _diastolicBpController = TextEditingController();
    _heartRateController = TextEditingController();
    _respiratoryRateController = TextEditingController();
    _urineVolumeController = TextEditingController();
    _timeSinceCatheterController = TextEditingController();
    _baseDeficitController = TextEditingController();
    _bloodLossPercentController = TextEditingController();
    _bloodLossMlController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _systolicBpController.dispose();
    _diastolicBpController.dispose();
    _heartRateController.dispose();
    _respiratoryRateController.dispose();
    _urineVolumeController.dispose();
    _timeSinceCatheterController.dispose();
    _baseDeficitController.dispose();
    _bloodLossPercentController.dispose();
    _bloodLossMlController.dispose();
    super.dispose();
  }

  String? _validateSystolicBp(String? value) {
    final error = validateSystolicBp(value);
    if (error != null) return error;

    // Additional validation: SBP must be greater than DBP
    final dbp = double.tryParse(_diastolicBpController.text);
    if (dbp != null && value != null && value.isNotEmpty) {
      final sbp = double.tryParse(value);
      if (sbp != null && sbp <= dbp) {
        return 'Systolic BP must be greater than Diastolic BP';
      }
    }

    return null;
  }

  String? _validateDiastolicBp(String? value) {
    final error = validateDiastolicBp(value);
    if (error != null) return error;

    // Additional validation: DBP must be less than SBP
    final sbp = double.tryParse(_systolicBpController.text);
    if (sbp != null && value != null && value.isNotEmpty) {
      final dbp = double.tryParse(value);
      if (dbp != null && sbp <= dbp) {
        return 'Diastolic BP must be less than Systolic BP';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(atlsShockFormProvider);
    final result = ref.watch(atlsShockResultProvider);
    final formNotifier = ref.read(atlsShockFormProvider.notifier);

    // Sync controllers with state
    if (_ageController.text != (formState.age ?? '')) {
      _ageController.text = formState.age ?? '';
    }
    if (_weightController.text != (formState.weightKg ?? '')) {
      _weightController.text = formState.weightKg ?? '';
    }
    if (_systolicBpController.text != (formState.systolicBp ?? '')) {
      _systolicBpController.text = formState.systolicBp ?? '';
    }
    if (_diastolicBpController.text != (formState.diastolicBp ?? '')) {
      _diastolicBpController.text = formState.diastolicBp ?? '';
    }
    if (_heartRateController.text != (formState.heartRate ?? '')) {
      _heartRateController.text = formState.heartRate ?? '';
    }
    if (_respiratoryRateController.text != (formState.respiratoryRate ?? '')) {
      _respiratoryRateController.text = formState.respiratoryRate ?? '';
    }
    if (_urineVolumeController.text != (formState.totalUrineVolume ?? '')) {
      _urineVolumeController.text = formState.totalUrineVolume ?? '';
    }
    if (_timeSinceCatheterController.text !=
        (formState.timeSinceCatheterHours ?? '')) {
      _timeSinceCatheterController.text = formState.timeSinceCatheterHours ?? '';
    }
    if (_baseDeficitController.text != (formState.baseDeficit ?? '')) {
      _baseDeficitController.text = formState.baseDeficit ?? '';
    }
    if (_bloodLossPercentController.text !=
        (formState.estimatedBloodLossPercent ?? '')) {
      _bloodLossPercentController.text =
          formState.estimatedBloodLossPercent ?? '';
    }
    if (_bloodLossMlController.text != (formState.estimatedBloodLossMl ?? '')) {
      _bloodLossMlController.text = formState.estimatedBloodLossMl ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATLS Shock Classification'),
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
                'ATLS Hemorrhagic Shock Classification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Classify trauma patients using ATLS 10th Edition criteria. Derived parameters are calculated automatically.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Demographics',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Age',
                unit: 'years',
                controller: _ageController,
                validator: validateAge,
                hintText: 'Optional',
                onChanged: (value) => formNotifier.setAge(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Weight',
                unit: 'kg',
                controller: _weightController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional, defaults to 70 kg
                  }
                  return validateWeight(value);
                },
                hintText: 'Optional (defaults to 70 kg)',
                onChanged: (value) =>
                    formNotifier.setWeightKg(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 24),
              Text(
                'Hemodynamics',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Pulse pressure is calculated automatically',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Systolic BP',
                unit: 'mmHg',
                controller: _systolicBpController,
                validator: _validateSystolicBp,
                onChanged: (value) {
                  formNotifier.setSystolicBp(value);
                  if (_formKey.currentState != null) {
                    _formKey.currentState!.validate();
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Diastolic BP',
                unit: 'mmHg',
                controller: _diastolicBpController,
                validator: _validateDiastolicBp,
                onChanged: (value) {
                  formNotifier.setDiastolicBp(value);
                  if (_formKey.currentState != null) {
                    _formKey.currentState!.validate();
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Heart Rate',
                unit: 'bpm',
                controller: _heartRateController,
                validator: validateHeartRate,
                hintText: 'Optional',
                onChanged: (value) =>
                    formNotifier.setHeartRate(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 24),
              Text(
                'Respiratory',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Respiratory Rate',
                unit: 'breaths/min',
                controller: _respiratoryRateController,
                validator: validateRespiratoryRate,
                onChanged: (value) => formNotifier.setRespiratoryRate(value),
              ),
              const SizedBox(height: 24),
              Text(
                'Renal Perfusion',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Urine output (mL/hr) is calculated automatically',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Total Urine Volume',
                unit: 'mL',
                controller: _urineVolumeController,
                validator: validateUrineVolumeOptional,
                hintText: 'Optional',
                onChanged: (value) =>
                    formNotifier.setTotalUrineVolume(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Time Since Catheter',
                unit: 'hours',
                controller: _timeSinceCatheterController,
                validator: validateTimeHoursOptional,
                hintText: 'Optional',
                onChanged: (value) => formNotifier.setTimeSinceCatheterHours(
                    value.isEmpty ? null : value),
              ),
              const SizedBox(height: 24),
              Text(
                'Neurological Status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MentalStatus>(
                initialValue: formState.mentalStatus,
                decoration: InputDecoration(
                  labelText: 'Mental Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: MentalStatus.normal,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: MentalStatus.slightlyAnxious,
                    child: Text('Slightly anxious'),
                  ),
                  DropdownMenuItem(
                    value: MentalStatus.mildlyAnxious,
                    child: Text('Mildly anxious'),
                  ),
                  DropdownMenuItem(
                    value: MentalStatus.anxiousConfused,
                    child: Text('Anxious / confused'),
                  ),
                  DropdownMenuItem(
                    value: MentalStatus.confusedLethargic,
                    child: Text('Confused / lethargic'),
                  ),
                ],
                onChanged: (value) => formNotifier.setMentalStatus(value),
                validator: (value) {
                  if (value == null) {
                    return 'Mental status is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Metabolic Marker (Optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Base Deficit',
                unit: 'mmol/L',
                controller: _baseDeficitController,
                validator: validateBaseDeficit,
                hintText: 'Optional',
                onChanged: (value) =>
                    formNotifier.setBaseDeficit(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 24),
              Text(
                'Estimated Blood Loss (Optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Estimated blood loss is often inaccurate; physiologic response is prioritized (ATLS).',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade900,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Blood Loss',
                unit: '% TBV',
                controller: _bloodLossPercentController,
                validator: validateBloodLossPercent,
                hintText: 'Optional',
                onChanged: (value) => formNotifier.setEstimatedBloodLossPercent(
                    value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),
              Text(
                'OR',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Blood Loss',
                unit: 'mL',
                controller: _bloodLossMlController,
                validator: validateBloodLossMl,
                hintText: 'Optional (for 70 kg patient)',
                onChanged: (value) => formNotifier.setEstimatedBloodLossMl(
                    value.isEmpty ? null : value),
              ),
              const SizedBox(height: 32),
              if (result != null) ...[
                const Divider(),
                const SizedBox(height: 16),
                AtlsShockResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
