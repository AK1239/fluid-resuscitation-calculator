import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/iron_sucrose/presentation/providers/iron_sucrose_providers.dart';
import 'package:chemical_app/features/iron_sucrose/presentation/widgets/iron_sucrose_result_widget.dart';

class IronSucroseScreen extends ConsumerStatefulWidget {
  const IronSucroseScreen({super.key});

  @override
  ConsumerState<IronSucroseScreen> createState() =>
      _IronSucroseScreenState();
}

class _IronSucroseScreenState extends ConsumerState<IronSucroseScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _actualHbController;
  late final TextEditingController _targetHbController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _actualHbController = TextEditingController();
    _targetHbController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _actualHbController.dispose();
    _targetHbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(ironSucroseFormProvider);
    final result = ref.watch(ironSucroseResultProvider);
    final formNotifier = ref.read(ironSucroseFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weightKg ?? '')) {
      _weightController.text = formState.weightKg ?? '';
    }
    if (_actualHbController.text != (formState.actualHb ?? '')) {
      _actualHbController.text = formState.actualHb ?? '';
    }
    if (_targetHbController.text != (formState.targetHb ?? '')) {
      _targetHbController.text = formState.targetHb ?? '';
    }

    // Determine default target Hb for display
    final defaultTargetHb = formState.isMale == true ? '13.0' : (formState.isMale == false ? '12.0' : '13.0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iron Sucrose (IV)'),
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
            Text(
              'Ganzoni Formula',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate iron sucrose dosing using the Ganzoni formula for IV iron replacement',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Body Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setWeightKg(value),
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
            CustomTextField(
              label: 'Actual Hemoglobin',
              unit: 'g/dL',
              controller: _actualHbController,
              validator: validateHemoglobin,
              onChanged: (value) => formNotifier.setActualHb(value),
              hintText: 'e.g., 7.0',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Target Hemoglobin',
              unit: 'g/dL',
              controller: _targetHbController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // Optional, will use default based on sex
                }
                return validateHemoglobin(value);
              },
              onChanged: (value) => formNotifier.setTargetHb(value),
              hintText: 'Default: $defaultTargetHb (${formState.isMale == true ? "Male" : formState.isMale == false ? "Female" : "Male"})',
            ),
            const SizedBox(height: 8),
            Text(
              'Default: 13 g/dL (men), 12 g/dL (women). Leave blank to use default.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Iron Stores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Include (500 mg)')),
                ButtonSegment(value: false, label: Text('Exclude')),
              ],
              selected: {formState.includeIronStores},
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setIncludeIronStores(selected.first);
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Include 500 mg iron stores for adults. Omit in elderly, CKD, or stepwise replacement.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              IronSucroseResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
