import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/map_pulse_pressure/presentation/providers/map_pulse_pressure_providers.dart';
import 'package:chemical_app/features/map_pulse_pressure/presentation/widgets/map_pulse_pressure_result_widget.dart';

class MapPulsePressureScreen extends ConsumerStatefulWidget {
  const MapPulsePressureScreen({super.key});

  @override
  ConsumerState<MapPulsePressureScreen> createState() =>
      _MapPulsePressureScreenState();
}

class _MapPulsePressureScreenState
    extends ConsumerState<MapPulsePressureScreen> {
  late final TextEditingController _systolicBpController;
  late final TextEditingController _diastolicBpController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _systolicBpController = TextEditingController();
    _diastolicBpController = TextEditingController();
  }

  @override
  void dispose() {
    _systolicBpController.dispose();
    _diastolicBpController.dispose();
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
    final formState = ref.watch(mapPulsePressureFormProvider);
    final result = ref.watch(mapPulsePressureResultProvider);
    final formNotifier = ref.read(mapPulsePressureFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_systolicBpController.text != (formState.systolicBp ?? '')) {
      _systolicBpController.text = formState.systolicBp ?? '';
    }
    if (_diastolicBpController.text != (formState.diastolicBp ?? '')) {
      _diastolicBpController.text = formState.diastolicBp ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MAP & Pulse Pressure Calculator'),
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
                'Blood Pressure Input',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter systolic and diastolic blood pressure values',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Systolic Blood Pressure',
                unit: 'mmHg',
                controller: _systolicBpController,
                validator: _validateSystolicBp,
                onChanged: (value) {
                  formNotifier.setSystolicBp(value);
                  // Trigger validation on the other field
                  if (_formKey.currentState != null) {
                    _formKey.currentState!.validate();
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Diastolic Blood Pressure',
                unit: 'mmHg',
                controller: _diastolicBpController,
                validator: _validateDiastolicBp,
                onChanged: (value) {
                  formNotifier.setDiastolicBp(value);
                  // Trigger validation on the other field
                  if (_formKey.currentState != null) {
                    _formKey.currentState!.validate();
                  }
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
                          'Validation Rules',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• SBP must be greater than DBP\n'
                      '• Acceptable range: 40–300 mmHg\n'
                      '• Both values are required',
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
                MapPulsePressureResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
