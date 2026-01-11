import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chemical_app/core/widgets/custom_text_field.dart';
import 'package:chemical_app/features/developmental_screening/domain/entities/developmental_assessment_result.dart';
import 'package:chemical_app/features/developmental_screening/presentation/providers/developmental_providers.dart';
import 'package:chemical_app/features/developmental_screening/presentation/widgets/developmental_result_widget.dart';

class DevelopmentalScreeningScreen extends ConsumerStatefulWidget {
  const DevelopmentalScreeningScreen({super.key});

  @override
  ConsumerState<DevelopmentalScreeningScreen> createState() =>
      _DevelopmentalScreeningScreenState();
}

class _DevelopmentalScreeningScreenState
    extends ConsumerState<DevelopmentalScreeningScreen> {
  late final TextEditingController _ageMonthsController;
  late final TextEditingController _correctedAgeMonthsController;

  @override
  void initState() {
    super.initState();
    _ageMonthsController = TextEditingController();
    _correctedAgeMonthsController = TextEditingController();
  }

  @override
  void dispose() {
    _ageMonthsController.dispose();
    _correctedAgeMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(developmentalFormProvider);
    final result = ref.watch(developmentalResultProvider);
    final formNotifier = ref.read(developmentalFormProvider.notifier);

    // Sync controllers with state
    if (_ageMonthsController.text != (formState.ageMonths ?? '')) {
      _ageMonthsController.text = formState.ageMonths ?? '';
    }
    if (_correctedAgeMonthsController.text !=
        (formState.correctedAgeMonths ?? '')) {
      _correctedAgeMonthsController.text = formState.correctedAgeMonths ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developmental Screening'),
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
              'Developmental Screening',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Screen developmental milestones and flag delays. This tool does not diagnose disease.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Age',
              unit: 'months',
              controller: _ageMonthsController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Age is required';
                }
                final age = int.tryParse(value);
                if (age == null) {
                  return 'Please enter a valid number';
                }
                if (age < 0) {
                  return 'Age cannot be negative';
                }
                if (age > 144) {
                  return 'Age must be ≤144 months (12 years)';
                }
                return null;
              },
              onChanged: (value) => formNotifier.setAgeMonths(value),
            ),
            const SizedBox(height: 16),
            Text(
              'Correct for prematurity? (if <2 years)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('No')),
                ButtonSegment(value: true, label: Text('Yes')),
              ],
              selected: {formState.isCorrectedAge},
              onSelectionChanged: (Set<bool> selected) {
                formNotifier.setIsCorrectedAge(selected.first);
              },
            ),
            if (formState.isCorrectedAge) ...[
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Corrected Age',
                unit: 'months',
                controller: _correctedAgeMonthsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Corrected age is required';
                  }
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Please enter a valid number';
                  }
                  if (age < 0) {
                    return 'Age cannot be negative';
                  }
                  return null;
                },
                onChanged: (value) =>
                    formNotifier.setCorrectedAgeMonths(value),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Developmental Domains',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Select classification for each domain based on observed abilities',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            ...DevelopmentalDomain.values.map((domain) => _DomainSelector(
                  domain: domain,
                  selectedClassification: formState.domainClassifications[domain],
                  onChanged: (classification) {
                    formNotifier.setDomainClassification(domain, classification);
                  },
                )),
            const SizedBox(height: 32),
            if (result != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              DevelopmentalResultWidget(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

class _DomainSelector extends StatelessWidget {
  final DevelopmentalDomain domain;
  final DomainClassification? selectedClassification;
  final ValueChanged<DomainClassification?> onChanged;

  const _DomainSelector({
    required this.domain,
    required this.selectedClassification,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            domain.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<DomainClassification?>(
            segments: [
              ButtonSegment(
                value: DomainClassification.appropriate,
                label: Text(
                  'Appropriate',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ButtonSegment(
                value: DomainClassification.borderline,
                label: Text(
                  'Borderline',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              ButtonSegment(
                value: DomainClassification.delayed,
                label: Text(
                  'Delayed',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
            selected: {
              if (selectedClassification != null) selectedClassification!,
            },
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<DomainClassification?> selected) {
              onChanged(selected.firstOrNull);
            },
          ),
        ],
      ),
    );
  }
}
