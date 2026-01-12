import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/electrolytes/sodium/presentation/providers/sodium_providers.dart';
import 'package:chemical_app/features/electrolytes/sodium/presentation/widgets/sodium_result_widget.dart';

class SodiumCorrectionScreen extends ConsumerStatefulWidget {
  const SodiumCorrectionScreen({super.key});

  @override
  ConsumerState<SodiumCorrectionScreen> createState() =>
      _SodiumCorrectionScreenState();
}

class _SodiumCorrectionScreenState
    extends ConsumerState<SodiumCorrectionScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _currentNaController;
  late final TextEditingController _targetNaController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _currentNaController = TextEditingController();
    _targetNaController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _currentNaController.dispose();
    _targetNaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(sodiumFormProvider);
    final result = ref.watch(sodiumResultProvider);
    final formNotifier = ref.read(sodiumFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_currentNaController.text != (formState.currentNa ?? '')) {
      _currentNaController.text = formState.currentNa ?? '';
    }
    if (_targetNaController.text != (formState.targetNa ?? '')) {
      _targetNaController.text = formState.targetNa ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sodium Correction'),
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
            Text('Sex', style: Theme.of(context).textTheme.titleMedium),
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
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Current Sodium',
              unit: 'mEq/L',
              controller: _currentNaController,
              validator: validateSodium,
              onChanged: (value) => formNotifier.setCurrentNa(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Target Sodium',
              unit: 'mEq/L',
              controller: _targetNaController,
              validator: (value) => validateTargetDifferent(
                targetValue: value,
                currentValue: formState.currentNa,
                fieldName: 'sodium',
              ),
              onChanged: (value) => formNotifier.setTargetNa(value),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  // Calculate correction rate (targetNa - currentNa)
                  double? correctionRate;
                  if (formState.currentNa != null &&
                      formState.targetNa != null) {
                    final current = double.tryParse(formState.currentNa!);
                    final target = double.tryParse(formState.targetNa!);
                    if (current != null && target != null) {
                      correctionRate = target - current;
                    }
                  }
                  return SodiumResultWidget(
                    result: result,
                    correctionRate: correctionRate,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
