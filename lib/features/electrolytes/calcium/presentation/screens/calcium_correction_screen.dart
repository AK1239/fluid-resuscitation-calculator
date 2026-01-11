import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/electrolytes/calcium/presentation/providers/calcium_providers.dart';
import 'package:chemical_app/features/electrolytes/calcium/presentation/widgets/calcium_result_widget.dart';

class CalciumCorrectionScreen extends ConsumerStatefulWidget {
  const CalciumCorrectionScreen({super.key});

  @override
  ConsumerState<CalciumCorrectionScreen> createState() =>
      _CalciumCorrectionScreenState();
}

class _CalciumCorrectionScreenState
    extends ConsumerState<CalciumCorrectionScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _currentCaController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _currentCaController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _currentCaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(calciumFormProvider);
    final result = ref.watch(calciumResultProvider);
    final formNotifier = ref.read(calciumFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_currentCaController.text != (formState.currentCa ?? '')) {
      _currentCaController.text = formState.currentCa ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcium Correction'),
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
              label: 'Current Calcium',
              unit: 'mmol/L',
              controller: _currentCaController,
              validator: validateCalcium,
              onChanged: (value) => formNotifier.setCurrentCa(value),
            ),
            const SizedBox(height: 24),
            Text(
              'Symptomatic?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Yes')),
                ButtonSegment(value: false, label: Text('No')),
              ],
              selected: {
                if (formState.isSymptomatic != null) formState.isSymptomatic!,
              },
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setIsSymptomatic(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              CalciumResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
