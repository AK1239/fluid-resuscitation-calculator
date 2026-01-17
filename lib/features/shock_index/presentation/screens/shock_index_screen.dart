import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/shock_index/presentation/providers/shock_index_providers.dart';
import 'package:chemical_app/features/shock_index/presentation/widgets/shock_index_result_widget.dart';

class ShockIndexScreen extends ConsumerStatefulWidget {
  const ShockIndexScreen({super.key});

  @override
  ConsumerState<ShockIndexScreen> createState() =>
      _ShockIndexScreenState();
}

class _ShockIndexScreenState extends ConsumerState<ShockIndexScreen> {
  late final TextEditingController _heartRateController;
  late final TextEditingController _systolicBpController;
  late final TextEditingController _ageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _heartRateController = TextEditingController();
    _systolicBpController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _heartRateController.dispose();
    _systolicBpController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(shockIndexFormProvider);
    final result = ref.watch(shockIndexResultProvider);
    final formNotifier = ref.read(shockIndexFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_heartRateController.text != (formState.heartRate ?? '')) {
      _heartRateController.text = formState.heartRate ?? '';
    }
    if (_systolicBpController.text != (formState.systolicBp ?? '')) {
      _systolicBpController.text = formState.systolicBp ?? '';
    }
    if (_ageController.text != (formState.age ?? '')) {
      _ageController.text = formState.age ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shock Index Calculator'),
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
                'Shock Index Calculation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate Shock Index (SI) and Trauma-Adjusted Shock Index (TASI) for risk stratification',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Heart Rate',
                unit: 'bpm',
                controller: _heartRateController,
                validator: validateHeartRate,
                onChanged: (value) => formNotifier.setHeartRate(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Systolic Blood Pressure',
                unit: 'mmHg',
                controller: _systolicBpController,
                validator: validateSystolicBp,
                onChanged: (value) => formNotifier.setSystolicBp(value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Age',
                unit: 'years',
                controller: _ageController,
                validator: validateAge,
                hintText: 'Optional (for TASI calculation)',
                onChanged: (value) => formNotifier.setAge(value.isEmpty ? null : value),
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
                          'About TASI',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TASI (Trauma-Adjusted Shock Index) is calculated only when age is provided. It is particularly useful for trauma patients to assess risk of severe injury and mortality.',
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
                ShockIndexResultWidget(result: result),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
