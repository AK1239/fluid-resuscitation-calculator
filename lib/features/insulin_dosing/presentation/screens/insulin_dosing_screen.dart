import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/insulin_dosing/presentation/providers/insulin_dosing_providers.dart';
import 'package:chemical_app/features/insulin_dosing/presentation/widgets/insulin_result_widget.dart';

class InsulinDosingScreen extends ConsumerStatefulWidget {
  const InsulinDosingScreen({super.key});

  @override
  ConsumerState<InsulinDosingScreen> createState() =>
      _InsulinDosingScreenState();
}

class _InsulinDosingScreenState extends ConsumerState<InsulinDosingScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _tddFactorController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _tddFactorController = TextEditingController(text: '0.5');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _tddFactorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(insulinDosingFormProvider);
    final result = ref.watch(insulinDosingResultProvider);
    final formNotifier = ref.read(insulinDosingFormProvider.notifier);

    // Sync controllers with state only if different (to avoid cursor jumping)
    if (_weightController.text != (formState.weight ?? '')) {
      _weightController.text = formState.weight ?? '';
    }
    if (_tddFactorController.text != (formState.tddFactor ?? '0.5')) {
      _tddFactorController.text = formState.tddFactor ?? '0.5';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adult Insulin Dosing'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/insulin-dosing'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2/3-1/3 Rule (Soluble vs Insoluble)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate insulin dosing using the classic 2/3-1/3 rule for mixed insulin',
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
              onChanged: (value) => formNotifier.setWeight(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'TDD Factor',
              unit: 'U/kg/day',
              controller: _tddFactorController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // Optional field, defaults to 0.5
                }
                final factor = double.tryParse(value);
                if (factor == null) {
                  return 'Please enter a valid number';
                }
                if (factor <= 0 || factor > 2.0) {
                  return 'Factor should be between 0.1 and 2.0 U/kg/day';
                }
                return null;
              },
              onChanged: (value) => formNotifier.setTddFactor(value),
              hintText: '0.5 (typical adult: 0.3-0.5)',
            ),
            const SizedBox(height: 8),
            Text(
              'Typical range: 0.3-0.5 U/kg/day for adults',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              InsulinResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}
