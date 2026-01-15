import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/core/utils/validators.dart';
import 'package:chemical_app/features/insulin_dosing/presentation/providers/pregnant_insulin_providers.dart';
import 'package:chemical_app/features/insulin_dosing/presentation/widgets/pregnant_insulin_result_widget.dart';

class PregnantInsulinDosingScreen extends ConsumerStatefulWidget {
  const PregnantInsulinDosingScreen({super.key});

  @override
  ConsumerState<PregnantInsulinDosingScreen> createState() =>
      _PregnantInsulinDosingScreenState();
}

class _PregnantInsulinDosingScreenState
    extends ConsumerState<PregnantInsulinDosingScreen> {
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(pregnantInsulinFormProvider);
    final result = ref.watch(pregnantInsulinResultProvider);
    final formNotifier = ref.read(pregnantInsulinFormProvider.notifier);

    // Sync controller with state
    if (_weightController.text != (formState.maternalWeight ?? '')) {
      _weightController.text = formState.maternalWeight ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnant Women Insulin Dosing'),
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
              'Initial Insulin Dosing During Pregnancy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate initial insulin dosing and step-by-step adjustment guidance based on blood glucose patterns',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Maternal Weight',
              unit: 'kg',
              controller: _weightController,
              validator: validateWeight,
              onChanged: (value) => formNotifier.setMaternalWeight(value),
            ),
            const SizedBox(height: 24),
            Text(
              'Gestational Trimester',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '1st', label: Text('1st')),
                ButtonSegment(value: '2nd', label: Text('2nd')),
                ButtonSegment(value: '3rd', label: Text('3rd')),
              ],
              selected: formState.trimester != null
                  ? {formState.trimester!}
                  : <String>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<String> selected) {
                formNotifier.setTrimester(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Obesity Class',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'None', label: Text('None')),
                ButtonSegment(value: 'Class II', label: Text('Class II')),
                ButtonSegment(value: 'Class III', label: Text('Class III')),
              ],
              selected: formState.obesityClass != null
                  ? {formState.obesityClass!}
                  : <String>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<String> selected) {
                formNotifier.setObesityClass(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Current Insulin Regimen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'None', label: Text('None')),
                ButtonSegment(value: 'Basal-bolus', label: Text('Basal-bolus')),
                ButtonSegment(
                  value: 'Four-injection regimen',
                  label: Text('Four-injection'),
                ),
              ],
              selected: formState.currentRegimen != null
                  ? {formState.currentRegimen!}
                  : <String>{},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<String> selected) {
                formNotifier.setCurrentRegimen(selected.firstOrNull);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Blood Glucose Pattern',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _GlucosePatternCheckbox(
              label: 'Elevated fasting glucose',
              value: formState.glucosePatterns.contains(
                'Elevated fasting glucose',
              ),
              onChanged: (value) =>
                  formNotifier.toggleGlucosePattern('Elevated fasting glucose'),
            ),
            _GlucosePatternCheckbox(
              label: 'Elevated post-breakfast glucose',
              value: formState.glucosePatterns.contains(
                'Elevated post-breakfast glucose',
              ),
              onChanged: (value) => formNotifier.toggleGlucosePattern(
                'Elevated post-breakfast glucose',
              ),
            ),
            _GlucosePatternCheckbox(
              label: 'Elevated post-lunch glucose',
              value: formState.glucosePatterns.contains(
                'Elevated post-lunch glucose',
              ),
              onChanged: (value) => formNotifier.toggleGlucosePattern(
                'Elevated post-lunch glucose',
              ),
            ),
            _GlucosePatternCheckbox(
              label: 'Elevated post-dinner glucose',
              value: formState.glucosePatterns.contains(
                'Elevated post-dinner glucose',
              ),
              onChanged: (value) => formNotifier.toggleGlucosePattern(
                'Elevated post-dinner glucose',
              ),
            ),
            _GlucosePatternCheckbox(
              label: 'Both preprandial and postprandial glucose elevated',
              value: formState.glucosePatterns.contains(
                'Both preprandial and postprandial glucose elevated',
              ),
              onChanged: (value) => formNotifier.toggleGlucosePattern(
                'Both preprandial and postprandial glucose elevated',
              ),
            ),
            _GlucosePatternCheckbox(
              label:
                  'Postprandial control only achievable with starvation ketosis',
              value: formState.glucosePatterns.contains(
                'Postprandial control only achievable with starvation ketosis',
              ),
              onChanged: (value) => formNotifier.toggleGlucosePattern(
                'Postprandial control only achievable with starvation ketosis',
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Doses require clinical confirmation. This calculator does not replace clinician judgment.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              PregnantInsulinResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

class _GlucosePatternCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  const _GlucosePatternCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: (newValue) => onChanged(newValue ?? false),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
