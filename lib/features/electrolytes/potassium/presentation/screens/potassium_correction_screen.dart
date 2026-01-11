import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/electrolytes/potassium/presentation/providers/potassium_providers.dart';
import 'package:chemical_app/features/electrolytes/potassium/presentation/widgets/potassium_result_widget.dart';

class PotassiumCorrectionScreen extends ConsumerStatefulWidget {
  const PotassiumCorrectionScreen({super.key});

  @override
  ConsumerState<PotassiumCorrectionScreen> createState() =>
      _PotassiumCorrectionScreenState();
}

class _PotassiumCorrectionScreenState
    extends ConsumerState<PotassiumCorrectionScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _currentKController;
  late final TextEditingController _targetKController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _currentKController = TextEditingController();
    _targetKController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _currentKController.dispose();
    _targetKController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(potassiumFormProvider);
    final result = ref.watch(potassiumResultProvider);
    final formNotifier = ref.read(potassiumFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_currentKController.text != (formState.currentK ?? '')) {
      _currentKController.text = formState.currentK ?? '';
    }
    if (_targetKController.text != (formState.targetK ?? '')) {
      _targetKController.text = formState.targetK ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Potassium Correction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Current Potassium',
              unit: 'mEq/L',
              controller: _currentKController,
              validator: validatePotassium,
              onChanged: (value) => formNotifier.setCurrentK(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Target Potassium',
              unit: 'mEq/L',
              controller: _targetKController,
              validator: (value) => validateTargetGreater(
                targetValue: value,
                currentValue: formState.currentK,
                fieldName: 'potassium',
              ),
              onChanged: (value) => formNotifier.setTargetK(value),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              PotassiumResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

